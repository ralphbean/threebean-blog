---
categories: fedora, zeromq, moksha, fedmsg
date: 2012/03/05 18:00:00
permalink: http://threebean.org/blog/messaging-sig-scheduling
title: Scheduling meetings for the Fedora Messaging SIG
---

So I'm spinning up the Fedora `Messaging SIG
<https://fedoraproject.org/wiki/Messaging_SIG>`_.  It's been sitting idle
for years; this time we're really going to do it.  We're going to put
`0mq <http://zeromq.org>`_ messaging hooks into bodhi, koji, pkgdb,
fas, you name it.

I'm building a python module called `fedmsg
<http://github.com/ralphbean/fedmsg>`_ to wrap it all and it comes with
`a proposal-in-development
<https://github.com/ralphbean/fedmsg/blob/develop/doc/proposal.rst>`_.  And if
you're not excited yet, we've already `0mq enabled the Moksha Hub
<https://fedorahosted.org/moksha/browser/?rev=91ef3643a9784b1329a68f732abf31745882709f>`_
and achieved a ~100 times speedup over AMQP/qpid.

The point of this post is to ask about times for an `IRC meeting
<https://fedoraproject.org/wiki/Meeting_channel>`_ of the Messaging
SIG.  Right now I'm thinking **Tuesdays at 16:00-17:00 UTC** in
``#fedora-meeting``.  If you're interested in helping with the effort but
that's a bad time for you, let me know and we'll work it out.

I'll be out at PyCon until next Wednesday; so the first meeting won't be until
March 20th at the earliest.

----

.. image:: http://threebean.org/blog/static/images/0mq-enable-all-the-things.jpg
