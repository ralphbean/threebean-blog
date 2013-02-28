---
categories: fedora, fedmsg, zeromq
date: 2013/02/28 12:00:00
permalink: http://threebean.org/blog/fedmsg-reliability
title: Fedmsg Reliability -- No More Dropped Messages?
---

Quick Timeline:

- **February, 2012** - I started thinking about fedmsg.
- **March, 2012** - `Development gets under way
  <http://meetbot.fedoraproject.org/fedora-meeting/2012-03-20/messaging-sig.2012-03-20-16.15.log.html>`_.
- **July, 2012** - `Stuff gets working in staging <http://threebean.org/blog/fedmsg-status>`_.
- **August-September, 2012** - The first messages hit production.  We notice that
  some messages are getting dropped.  We chalk it up to
  programming/configuration oversights.  We are correct about that in some
  cases.
- **October-November, 2012** - Some messages are still getting dropped.  Theory
  develops that it is due to zeromq2's lack of TCP_KEEPALIVE.  It takes time
  to package zeromq3 and test this, integrate it with Twisted bindings, and
  deploy.  More message sources come online during this period.  Other stuff
  like externally consuming messages
  `[1] <http://threebean.org/blog/fedmsg-tutorial-consuming-fas-stg>`_
  `[2] <http://threebean.org/blog/zeromq-and-fedmsg-diy>`_,
  datanommer
  `[3] <http://threebean.org/blog/datanommer-and-fedmsg-activity>`_
  `[4] <http://threebean.org/blog/datanommer-and-gource>`_,
  and identica
  `[5] <http://threebean.org/blog/fedmsg-on-identica>`_ happen too.
- **January, 2013** - I enabled the TCP_KEEPALIVE bits in production `at FUDCon
  Lawrence <http://threebean.org/blog/fudcon-lawrence/>`_.

I haven't noticed any dropped messages since then:  a marked improvement.
However, our *volume* of messages is so much higher now that it is difficult
to eyeball.  If *you* notice dropped messages, please let me know in
``#fedora-apps`` on freenode.
