---
categories: fedora, fedmsg, collectd
date: 2014/09/29 10:00:00
permalink: http://threebean.org/blog/fedmsg-health-dashboard
title: Fedmsg Health Dashboard
---
We've had `collectd stats on fedmsg for some time
<http://threebean.org/blog/fedmsg-collectd-ng/>`_ now but it `keeps getting
better <https://github.com/mokshaproject/moksha/pull/20>`_.  You can see the
new pieces starting to come together on `this little fedmsg-health dashboard
<http://threebean.org/fedmsg-health.html>`_ I put together.

The graphs on the right side -- the backlog -- we have had for a few months
now.  The graphs on the left and center indicate respectively how many messages
were received by and how many messages were processed by a given daemon.  The
backlog graph on the right shows a sort of 'difference' between those two --
"how many messages are left in my local queue that need to be processed".

Having all these will help to diagnose the situation when our daemons start to
become noticably clogged and delayed.  "Did we just experience a surge of
messages (i.e. a mass rebuild)?  Or is our rate of handling messages slowing
down for some reason (i.e., slow database)?"

.. image:: http://threebean.org/fedmsg-health.png
   :width: 645px
   :target: http://threebean.org/fedmsg-health.html

This is mostly for internal infrastructure team use -- but I thought it would
be neat to share.
