---
categories: fedora, fedmsg, collectd
date: 2014/05/01 9:35:00
permalink: http://threebean.org/blog/fedmsg-collectd-ng
title: monitoring fedmsg process health in collectd
---

Happy May Day!  Almost a year ago, we started `monitoring fedmsg throughput in
collectd <http://threebean.org/blog/fedmsg-collectd>`_.

Nowadays, we have many more message types on the bus and a much higher volume
too.  I started to get worried about the performance of the daemons handling
messages.  We have log files in ``/var/log/fedmsg/``, but it required someone
familiar to go and look at them.  Too manual.

Well, over a month ago we `cooked up an idea
<http://threebean.org/blog/threading-moksha/>`_ to expose more of the
``fedmsg-hub``'s internals for monitoring.  That stuff has all been implemented
and released after some sprint-work at PyCon.  Janez Nemanič is working on
`nagios checks for all this
<https://fedorahosted.org/fedora-infrastructure/ticket/4044>`_ and just
yesterday I wrote `the collectd plugin
<http://infrastructure.fedoraproject.org/cgit/ansible.git/commit/?id=b5f6044085c49061bb605bcac15c5fca862fdc89>`_
to pull all that information in for visualization.  Take a look:

Here's the "backlog" of the `Fedora Badges <https://badges.fedoraproject.org>`_
backend.  It is a graph of how many messages have arrived in its internal
queue, but that it has not yet dealt with.  Smaller numbers are better here.
As you can see, the badges awarder mostly stays on top of its workload.  It can
award badges almost as rapidly as it is notified of events.

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=badges-backend01.phx2.fedoraproject.org;plugin=fedmsg;plugin_instance=hub;type=queue_length;type_instance=FedoraBadgesConsumer_backlog;begin=-86400
   :width: 80%

Here is the same graph for `summershum
<https://lists.fedoraproject.org/pipermail/infrastructure/2014-February/014059.html>`_.
It is a daemon that watches the bus, and when new source tarballs are uploaded
to the lookaside cache, it downloads them, extracts the contents, and then
computes and stores hashes of all the source files.  The graph here has a
different profile.  Lookaside uploads occur relatively infrequently, but when
they do occur summershum undertakes a significant workload:

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=summershum01.phx2.fedoraproject.org;plugin=fedmsg;plugin_instance=hub;type=queue_length;type_instance=SummerShumConsumer_backlog;begin=-86400
   :width: 80%

Lastly, and this is my favorite, this is the backend for `Fedora Notifications
<https://apps.fedoraproject.org/notifications>`_.  It has some inefficiencies
that need to be dealt with, which you can plainly see from the profile here.
On some occasions, its backlog will grow to hundreds of messages.

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=notifs-backend01.phx2.fedoraproject.org;plugin=fedmsg;plugin_instance=hub;type=queue_length;type_instance=FMNConsumer_backlog;begin=-86400
   :width: 80%

For the curious, its workload looks like this:  "when a message arrives,
compare it against rules defined for every user in our database.  If there are
any matches, then forward that message on to that user."  The inefficiencies
stem almost entirely from database queries.  For *every* message that arrives,
it extracts *every* rule for *every* user from the database across the network.
Unnecessary.  We could cache all that in memory and have the backend then
intelligently invalidate its own cache when a user changes a preference rule in
the frontend.  We could signal that such a change has been made with, you
guessed it, a fedmsg message.  Such a change is probably all that's needed...

...but *now* we have *graphs*.  And with graphs we can measure how much
improvement we do or don't get.  Much nicer than guessing.
