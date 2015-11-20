---
categories: python,fedora,cache
date: 2015/11/20 13:20:00
permalink: http://threebean.org/blog/history-of-fedora-packages
title: Backend rewrite of the Fedora-Packages webapp
---

Just yesterday, `we deployed
<https://lists.fedoraproject.org/archives/list/devel-announce%40lists.fedoraproject.org/thread/RMLV2CYKW4EEGDY3LTUBUOHM2DJ25BNJ/>`_
the ``3.0`` version -- a rewrite -- of the `fedora-packages webapp
<https://apps.fedoraproject.org/packages/>`_ (`source
<https://github.com/fedora-infra/fedora-packages>`_).  For years now, it has
suffered from data corruption problems that stemmed from multiple processes all
fighting over resources stored on a gluster share between the app nodes.
Gluster's not to blame.  It's that too many things were trying to be "helpful"
and no amount of locking would seem to solve the problem.

tl;dr
-----
We have lots of old, open tickets about various kinds of data being missing
from the webapp.  Those are hopefully all resolved now.  Please use it and
`file new tickets <https://github.com/fedora-infra/fedora-packages/issues/>`_
if you notice bugs. Patience appreciated.

Architecture
------------

Let's take a look at the internal architecture of the app.  It's a cool idea.
It doesn't really have any data of its own, but it is a layer on top of our
other packaging apps; it just re-presents all of their data in one place.
This is the "microservices" dream?

Here we have a diagram of the system as it was originally written in its "2.0" state.

.. image:: http://threebean.org/blog/static/images/fedora-packages/diagram1.png
   :width: 600px

HTTP requests come in to the app either for some initial page load or for some
kind of subsequent ajax data.  The app hands control off to one of two major
subsystems -- a "widgets" controller that handles rendering all the tabs, and a
"connectors" dispatcher that handles gathering and returning data.  The widgets
themselves actually re-use the connectors under the hood to prepare their
initial data.

More complicated than that
--------------------------

First, there are only three widgets/connectors depicted above, but really there
are many more (a search connector, a bugzilla connector, etc..).  Some of them
were written, but never included any place in the app (in the latest pass
through the code, I found an unused ``TorrentConnector`` which returned data
about Fedora torrent downloads!).

Note that over the last few years, the widgets subsystem has remained largely
unchanged. It is a source of technical debt, but it hasn't been the cause of
any major breakages, so we haven't had cause to touch it.  The widgets have
metaclasses under the hood, can be nested into a hierarchy, and can declare
js/css resource dependencies in a tree.  It's pretty massive -- all on the
server-side.

There is also (not depicted) an impenetrable  thicket of javascript that gets
served to clients which in turn wires up a lot of the client-side behavior.

Lastly, there are (were) a variety of cronjobs (not depicted) which would
update local data for a subset of the connectors.  Notably, there was a
yum-sync cronjob that would pull the latest yum repodata down to disk.  There
was a cronjob that would pull down all the latest koji builds "since the last
time it ran". Another would crawl through the local yum repos and rebuild the
search index based on what it thought was in rawhide.

Just... keep all that in mind.

Focus on the connectors
-----------------------

Here's a simpler drawing:

.. image:: http://threebean.org/blog/static/images/fedora-packages/diagram2.png
   :width: 600px

So, when it was first released, this beast was too slow.  The koji connector
would take *forever* to return.. and bugzilla even longer.

To try and make things snappy, I added a cache layer internally, like this:

.. image:: http://threebean.org/blog/static/images/fedora-packages/diagram3.png
   :width: 600px

The "connector middleware" and the widget subsystem would *both* use the cache,
and things became somewhat more nice! However, the cache expiry was too long,
and people complained (rightly) that the data was often out of date.
So, we reduced it and had the cache expire every 5 minutes.  But.. that
defeated the whole point.  Every time you requested a page, you were almost
certainly guaranteed that the cache would already be expired and you'd have to
wait and wait for the connectors to do their heavy-lifting anyways.

Async Refresh
-------------

That's when (back in 2013), I got `this idea
<http://threebean.org/blog/async-caching-fedora-packages/>`_ to introduce an
asynchronous cache worker, that looked something like this.

.. image:: http://threebean.org/blog/static/images/fedora-packages/diagram4.png
   :width: 600px

If you requested a page and the cache data was *too old*, the web app would
just return the old data to you anyways, but it would also stick a note in a
redis queue telling a cache worker daemon that it should rebuild that cache
value for the next request.

I thought it was pretty cool.  You could request the page and sometimes get old
data, but if you refreshed shortly after that you'd have the new stuff.  Pages
that were "hot" (being clicked on by multiple people) appeared to be kept fresh
more regularly.

However, a page that was "cold" -- something that someone would visit once
every few months -- would often present horribly old information to the
requester.  People frequently complained that the app was just out of sync entirely.

To make matters worse, it **was** out of sync entirely!  We had a separate set
of issues with the cron jobs (the one that would update the list of koji builds
and the one that would update the yum cache). Sometimes, the webapp, the cache
worker, and the cronjob would all try to modify the same files at the same time
and horribly corrupt things.  The cronjob would crash, and it would never go
back to find the old builds that it failed to ingest.  It was a mess.

The latest rewrite
------------------

Two really good decisions were made in the latest rewrite:

- First, we dispensed *entirely* with the local yum repos (which were the
  resources most prone to corruption).  We moved that out to an `external
  network service called mdapi <https://apps.fedoraproject.org/mdapi>`_ which
  is very cool in its own right, but it makes the data story much more simple
  for the fedora-packages app.

- Second, I replaced the reactive async cache worker with an active
  event-driven cache worker.  Instead of updating the cache when a user
  requests the page, we update the cache when the resources change *in the
  system we would query*.  For example, when someone does a new build in the
  buildsystem, the buildsystem publishes a message to our message bus.  The
  cache worker receives that event -- it first deletes the old JSON data for
  the builds page for that package in the cache, and then it calls the
  ``KojiConnector`` with the appropriate arguments to re-fill that cache value
  with the latest data.

  We turned off expiration in the cache all-together so that values never
  expire on their own.  The outcome here is that the page data should be
  *freshly cached before anyone requests it* -- active cache invalidation.

.. image:: http://threebean.org/blog/static/images/fedora-packages/diagram5.png
   :width: 600px

With those two changes, we were able to kill off *all* of the cronjobs.

Some additional complications:  first, the cache worker *also* updates a local
xapian database in response to events (in addition to the expiration-less
cache), but it is the only process doing so and so can hopefully avoid further
corruption issues.

Second, the bugzilla connector can't work like this yet because we don't yet
have bugzilla events on our message bus.  Zod-willing, we'll have them in
January 2016 and we can flip that part on.  The bugs tab will be slower than we
like until then.

Looking forwards
----------------

We're building the `fedora-hubs <https://pagure.io/fedora-hubs>`_ backend with
the same kind of architecture (actively-invalidated cache of tough-to-assemble
page data), so, we get to learn practical lessons here about what works and
what doesn't.

Do hit us up in ``#fedora-apps`` on freenode if you want to help out, chat, or
lurk.  I'll be cleaning up any loose bugs on this deployment in the coming
weeks while starting work on a new `pdc-updater
<https://github.com/fedora-infra/pdc-updater>`_ project.
