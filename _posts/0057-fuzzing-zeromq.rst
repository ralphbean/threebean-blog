---
categories: fedora, python, zeromq
date: 2012/09/18 16:30:00
permalink: http://threebean.org/blog/fuzzing-zeromq
title: Fuzzing zeromq
---

So, my project for Fedora Infrastructure (`fedmsg
<http://fedmsg.rtfd.org>`_) connects around with `zeromq
<http://zeromq.org>`_.  Way back in the Spring of this year, `skvidal
<http://skvidal.wordpress.com>`_ suggested that I "fuzz" it and see what
happens, "fuzz" meaning try to cram random bits down its tubes.

I have `a little pair of python scripts <https://gist.github.com/3745381>`_
that I carry around in my ``~/scratch/`` dir to debug various zeromq
situations.  One of the scripts is ``topics_pub.py``; it *binds* to an
endpoint and publishes messages on topics.  The other is ``topics_sub.py``
which *connects* to an endpoint and prints messages it receives to stdout.

To fuzz the subscriber, I had it connect to a garbage source built with
``/dev/random`` and ``netcat``.  In one terminal, I ran::

  $ cat /dev/random | nc -l 3005

and in the other, I ran::

  $ python topics_sub.py "tcp://*:3005"

... and nothing happened.

To fuzz the publisher, I hooked ``/dev/random`` up to ``telnet``::

  $ python topics_pub.py "tcp://127.0.0.1:3005"
  $ cat /dev/random | telnet 127.0.0.1 3005

... and it didn't fall over.  Encouraging.

