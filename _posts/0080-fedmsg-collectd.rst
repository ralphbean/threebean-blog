---
categories: fedora, fedmsg
date: 2013/04/18 23:00:00
permalink: http://threebean.org/blog/fedmsg-collectd
title: fedmsg messages in collectd
---

I wrote `the code <http://bit.ly/17752gP>`_
for it back in 2012, but it wasn't until today that I got Fedora
Infrastructure's `collectd instance
<https://admin.fedoraproject.org/collectd>`_ tracking `fedmsg
<http://fedmsg.com>`_ messages:

.. image:: https://admin.fedoraproject.org/collectd/bin/graph.cgi?hostname=busgateway01;plugin=fedmsg;type=fedmsg_wallboard;begin=-604800
   :width: 80%

We're tracking fedmsg messages in other places like datanommer, irc, and
the `identi.ca bot <http://identi.ca/fedmsgbot>`_, but having them in
collectd is cool because *that's* the place we go to monitor all our other
system stats.  All of our stuff in one place (but not all of our eggs in
one basket).

You can `click here <http://bit.ly/17751JK>`_ to mess around with it.
