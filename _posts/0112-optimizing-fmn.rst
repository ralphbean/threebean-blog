---
categories: fedora, fedmsg, fmn
date: 2014/06/13 16:45:00
permalink: http://threebean.org/blog/optimizing-fmn
title: Optimizing "Fedora Notifications"
---

Back story:  with `some hacks <http://threebean.org/blog/threading-moksha>`_,
we introduced `new monitoring <http://threebean.org/blog/fedmsg-collectd-ng>`_
for `fedmsg <http://fedmsg.com>`_.

The good news is, most everything was smooth sailing.. with one exception.
`FMN <https://apps.fedoraproject.org/notifications>`_ has been having a
terrible time staying on top of its workload.  After we brought the `arm koji
hub <https://koji.arm.fedoraproject.org>`_ onto the fedmsg bus, FMN just
started to drown.

Bad News Bears
--------------

Here's a depiction of its "queue length" or backlog -- the number of messages
it has received, but has yet to process.  (We want that number to be as low as
possible, such that it handles messages as soon as they arrive.)

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=notifs-backend01.phx2.fedoraproject.org;plugin=fedmsg;plugin_instance=hub;type=queue_length;type_instance=FMNConsumer_backlog;begin=1402283458;end=1402408516
   :width: 80%

You read it right -- that's *hundreds of thousands* of messages
still-to-process.  You wouldn't get your messages until the day-after and
besides which, fmn would never get it under control.  The backlog would just
continue to pile-up until we restarted it, dropping all buffered messages.

Optimizing
----------

We introduced a couple improvements to `the backend code
<https://github.com/fedora-infra/fmn.consumer>`_ which have produced favorable
results.

**Firstly**, we rewrote the pkgdb caching mechanism twice over.  It is typical
for users to have a rule in their preferences like "notify me of any event
having anything to do with a package that I have commit access on".  That
commit access data is stored in pkgdb (now pkgdb2).  In order for that to work,
the fmn backend has to query pkgdb for what packages you have commit access on.

In the first revision, we would cache the acls per-user.  Our call to pkgdb2 to
get all that information per-user took around 15 seconds to execute and we
would cache the results for around 5 minutes.  This became untenable quickly:
the closer we grew to 20 test users, we ended up just querying pkgdb all day.
Math it out:  20 users, 15 seconds per query.  5 minutes to cache all 20 users,
and by that time, the cache of the first user had expired so we had to start
over.

We moved temporarily to caching per-package, which was at least tenable.

**Secondly**, we (smartly, I think) reorganized the way the fmn backend manages
its own database.  In the first revision of the stack, every time a new message
would arrive FMN would: query the database for every rule and preference for
every user, load those into memory, figure out where it should forward the
message, do that, and then drop the rules and preferences (only to load them
again a moment later).

Now, we cache the entire ruleset in memory (forever).  The frontend is
instrumented to publish fedmsg messages whenever a user edits something in
their profile -- when the backend receives such a message, it invalidates its
cache and reloads from the database (i.e., infrequently and as-needed).

We ended up applying the same scheme to the pkgdb caching, such that whenever a
message arrives indicating that someone's acls have changed somewhere in pkgdb,
we delete that portion of our local cache for that user which is then refreshed
the next time it is needed.

Things get better
-----------------

Take a look now:

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=notifs-backend01.phx2.fedoraproject.org;plugin=fedmsg;plugin_instance=hub;type=queue_length;type_instance=FMNConsumer_backlog;begin=1402666182;end=1402691209
   :width: 80%

It still spikes when major events happen, but it quickly gets things under
control again.  More to come... (and, if you love optimizing stuff and looking
for hotspots, please come get involved; there are too many things to hack on).

Join the Fedora Infrastructure Apps team in ``#fedora-apps`` on freenode!
