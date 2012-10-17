---
categories: fedora, fedmsg, datanommer
date: 2012/10/16 21:00:00
permalink: http://threebean.org/blog/datanommer-and-fedmsg-activity
title: The first week of fedmsg events in datanommer's DB
---

Last week we finally got `datanommer <http://github.com/ralphbean/datanommer>`_
working in our production environment.  Originally `ianweller's idea
<https://fedoraproject.org/wiki/User:Ianweller/statistics_plus_plus>`_, it is a
consumer that sits listening to the `fedmsg bus <http://fedmsg.rtfd.org>`_ and
logs every event to a postgresql database.

It's nice to have in place now.  With the data we can make more confident
statements about what's happening on the bus... we can record a series of
events from our production environment... play those back in staging for
testing scenarios... and most importantly, we can make pretty graphs.

I made the following with the output of the ``datanommer-dump``
command and `these scripts <http://bit.ly/Tscn1k>`_:

.. image:: https://raw.github.com/ralphbean/datanommer/develop/tools/first-week-of-datanommer/activity.png
   :target: https://github.com/ralphbean/datanommer/blob/develop/tools/first-week-of-datanommer/activity.png

You can see the ups and downs of the day/night cycle and you can see activity dip
on the weekend, too.  Neat!
