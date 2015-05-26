---
categories: fedora, statscache, datagrepper
date: 2015/05/26 14:15:00
permalink: http://threebean.org/blog/statscache
title: statscache - thoughts on a new Fedora Infrastructure backend service
---

We've been working on a new backend service called `statscache
<https://github.com/fedora-infra/statscache>`_.  It's not even close to done,
but it has gotten to the point that it deserves an introduction.

A little preamble:  the `Fedora Infrastructure team
<http://fedoraproject.org/wiki/Infrastructure>`_ runs `~40 web services
<https://apps.fedoraproject.org/>`_ which facilitate the production of the
actual OS by the community.  Community ongoings are channeled through irc
meetings (for which we have `a bot <http://fedoraproject.org/wiki/Zodbot>`_),
`wiki pages <https://fedoraproject.org/wiki>`_ (which we host), and more.
Packages are built in our `buildsystem <http://koji.fedoraproject.org>`_.  QA
feedback goes through lots of channels, but particularly the `updates system
<https://admin.fedoraproject.org/updates>`_. There are lots of systems with
many heterogenous interfaces.  About three years ago, we started linking them
all together with `a common message bus <http://fedmsg.com>`_ on the backend
and this has granted us a handful of advantages.  One of them is that we have a
common history for all Fedora development activity (and to a lesser extent,
community activity).

There is a `web interface <https://apps.fedoraproject.org/datagrepper>`_ to
this common history called datagrepper.  Here are some example queries to get
the feel for it:

- `all messages from the last five minutes <https://apps.fedoraproject.org/datagrepper/raw?delta=300>`_
- `all karma commands from IRC <https://apps.fedoraproject.org/datagrepper/raw?category=irc>`_
- `all messages about the package firefox <https://apps.fedoraproject.org/datagrepper/raw?package=firefox>`_

On top of this history API, we can build other things -- the first of which was
the `release engineering dashboard
<https://apps.fedoraproject.org/releng-dash>`_. It is a pure html/js app -- it
has no backend server components of its own (no python) -- it directs your
browser to make *many* different queries to the datagrepper API. It 1) asks for
*all* the recent message types for X, Y, and Z categories, 2) locally filters
out the irrelevant ones, and 3) tries to render only the latest events.

It is arguably useful.  `QA <http://fedoraproject.org/wiki/QA>`_ likes it so
they can see what new things are available to test.  In the future, perhaps the
`websites team <http://fedoraproject.org/wiki/Websites>`_ can use it to get the
`latest AMIs <https://apps.fedoraproject.org/datagrepper/raw?category=fedimg>`_
for images uploaded to amazon, so they can in turn update `getfedora.org
<https://getfedora.org>`_.

It is arguably slow.  I mean, that thing *really crawls* when you try to load
the page and we've already put `some tweaks
<http://threebean.org/blog/revisiting-datagrepper-performance/>`_ in place to
try to make it incrementally faster.  We need a new architecture.

**Enter statscache**.  The releng dash is pulling raw data from the server to
itself, and then computing some 'latest values' from them to display.  Why
don't we compute and cache those latest values in a server-side service
instead?  This way they'll be ready and available for snappy delivery to web
clients.

`@rtnpro <https://github.com/rtnpro>`_ and I have been working on it for the
past few months and have a nice basis for the framework.  It can currently
cache some rudimentary stuff and most of the releng-dash information, but we
have big plans.  It is pluggable -- so if there's a new "thing you want to know
about", you can write a statscache plugin for it, install it, and we'll start
tracking that statistics over time. There are all sorts of metrics -- both the
well understood kind and the half-baked kind -- that we can track and have
available for visualization.

We can then plug those graphs in as widgets to the larger `Fedora Hubs effort
<http://fedoraproject.org/wiki/Fedora_Hubs>`_ we're embarking on (visit the
wiki page to learn about it).  Imagine user profile pages there with nice
`d3.js <http://d3js.org/>`_ graphs of personal and aggregate community
activity.  Something in the style of the `calendar of contributions
<https://github.com/blog/1360-introducing-contributions>`_ graph that GitHub
puts on user profile pages would be a perfect fit (but for Fedora activity --
not GitHub activity).

Check out the code:

- the `main repo <https://github.com/fedora-infra/statscache>`_
- the `plugins repo <https://github.com/fedora-infra/statscache_plugins>`_

At this point we need:

- New plugins of all kinds.  What kinds of running stats/metrics would be interesting?
- By writing plugins that will flex the API of the framework,
  we want to find edge cases that cannot be easily coded.  With those we can in
  turn adjust the framework now -- early -- instead of 6 months from now when
  we have other code relying on this.
- A set of example visualizations would be nice.  I don't think statscache
  should *host or serve* the visualization, but it will help to build a few toy
  ones in an ``examples/`` directory to make sure the statscache API can be
  used sanely.  We've been doing this with a `statscache branch of the releng
  dash repo <https://github.com/fedora-infra/fedora-releng-dash/pull/20>`_.
- Unit/functional test cases.  We have some, but could use more.
- Stress testing.  With a handful of plugins, how much does the backend suffer under load?
- Plugin discovery.  It would be nice to have an API endpoint we can query to
  find out what plugins are installed and active on the server.
- Chrome around the web interface?  It currently serves only JSON responses,
  but a nice little documentation page that will introduce a new user to the
  API would be good (kind of like datagrepper itself).
- A deployment plan.  We're pretty good at doing this now so it shouldn't be problematic.
