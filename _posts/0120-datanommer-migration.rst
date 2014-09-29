---
categories: fedora, fedmsg, datanommer
date: 2014/09/29 11:30:00
permalink: http://threebean.org/blog/datanommer-database-migrated
title: Datanommer database migrated to a new db host
---

The bad news:  our database of all the fedmsg messages ever - it's getting
slower and slower.  If you use `datagrepper
<https://apps.fedoraproject.org/datagrepper>`_ to query it with any frequency,
you will have noticed this.  The dynamics of it are simple: we are always
storing new messages in postgres and none of them ever get removed.  We're over
13 million messages now.

When we first launched datagrepper for public queries, they took around 3-4s to
complete.  We called this acceptable, and even fast enough to build services
that relied extensively on it like the `releng dashboard
<https://apps.fedoraproject.org/releng-dash>`_.  As things got slower, queries
could take around 60s and pages like the releng dash that made 20 some queries
to it would take a **long** time to render fully.

Three Possible Solutions
------------------------

We started looking at ways out of this jam.

**NoSQL** -- funny, the `initial implementation of datanommer written on top of
mongodb
<https://github.com/fedora-infra/datanommer/commit/78b6f120d7b57cbe6efc9dbbd1a7de02f4f08744>`_
and we are now re-considering it.  At Flock 2014, `yograterol
<https://fedoraproject.org/wiki/User:Yograterol>`_ gave `a talk on NoSQL in
Fedora Infra <https://www.youtube.com/watch?v=leRlVbHIQQs>`_ which has sparked
off a series of email threads and an experiment by `pingou
<http://blog.pingoured.fr/>`_ to import the existing postgres data into mongo.
The next step there is to run some comparison queries when we get time to see
if one backend is superior to the other in respects that we care about.

**Sharding** -- another idea is to *horizontally partition* our giant
``messages`` table in postgres.  We could have one ``hot_messages`` table that
holds only the messages from the last week or month, another ``warm_messages``
table that holds messages from the last 6 months or so, and a third
``cold_messages`` table that holds the rest of the messages from time
immemorial.  In one version of this scheme, no messages are duplicated between
the tables and we have a cronjob that periodically (daily?) moves messages from
hot to warm and from warm to cold.  This is likely to increase performance for
*most* use cases, since most people are only ever interested in the *latest*
data on topic X, Y or Z.  If someone is interested in getting data from way
back in time, they typically also have the time to sit around and wait for it.
All of this, of course, would be an implementation detail hidden inside of the
datagrepper and datanommer packages.  End users would simply query for messages
as they do now and the service would transparently query the correct tables
under the hood.

**PG Tools** -- While looking into all of this, we found some postgres tools
that might just help our problems short term (although we haven't actually
gotten a chance to try them yet).  `pg_reorg
<http://reorg.projects.pgfoundry.org/pg_reorg.html>`_ and `pg_repack
<https://reorg.github.io/pg_repack/>`_ look promising.  When preparing
to test other options, we pulled the `datanommer snapshot
<https://infrastructure.fedoraproject.org/infra/db-dumps/>`_ down and imported
it on a cloud node and found, surprisingly, that it was much faster than our
production instance.  We also haven't had time to investigate this, but my bet
is that when it is importing data for the first time, postgres has all the time
in the world to pack and store the data internally in a way that it knows how
to optimally query.  This needs more thought -- if simple postgres tools will
solve our problem, then we'll save a lot more engineering time than if we try
to rewrite *everything* against mongo or rewrite *everything* against a cascade
of tables (sharding).

Meanwhile
---------

Doom arrived.

.. image:: http://threebean.org/blog/static/images/doom.png
   :alt: Graph of the datanommer backlog.  It should stay at 0 all the time.

The above is a graph of the datanommer *backlog* from last week.  The number on
the chart represents how many messages have arrived in datanommer's local
queue, but which have not been processed yet and inserted into the database.
We want the number to be at 0 all the time -- indicating that messages are put
into the database as soon as they arrive.

Last week, we hit an emergency scenario -- a `critical point
<https://en.wikipedia.org/wiki/Critical_point_%28thermodynamics%29>`_ -- where
datanommer couldn't store messages as fast as they were arriving.

Now.. what caused this?  It wasn't that we were receiving messages at a higher
than normal rate, it was that the database's slowness passed a critical point,
the process of inserting a message was now taking *too long*, the rate at which
we were processing messages was lower than necessary (see my other `post on new
measurements <http://threebean.org/blog/fedmsg-health-dashboard/>`_).

Migration
---------

The rhel6 db host for datanommer was pegged so we decided to try and migrate it
to a new rhel7 vm with more cpus as a first bet.  This turned out to work much
better than I expected.

Times for simple queries are down from 500 seconds to 4 seconds and our
datanommer backlog graph is back down to zero.

The migration took longer than I expected and we have an unfortunate 2 hour gap
in the datanommer history now.  With some more forethought, we could get around
this by standing up a temporary second db to store messages during the outage,
and then adding those back to the main db afterwards.  If we can get some spare
cycles to set this up and try it out, maybe we can have it in place for next
time.

For now, the situation seems to be under control but is not solved in the long
run.  If you have any interest in helping us with any of the three possible
longer term solutions mentioned above (or have ideas about a fourth) please
do join us in `#fedora-apps` on freenode and lend a hand.
