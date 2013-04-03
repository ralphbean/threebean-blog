---
categories: fedora, fedmsg, python
date: 2013/04/03 09:15:00
permalink: http://threebean.org/blog/fedmsg-topics
title: Now Available - List of fedmsg Topics
---

`fedmsg <http://fedmsg.com>`_ (the Fedora Infrastructure Message Bus) now has
a `full list of published message topics
<http://fedmsg.com/en/latest/topics/>`_ with example messages and more.

For instance, one of the topics on which the koji build system emits messages
is `org.fedoraproject.prod.buildsys.build.state.change
<http://www.fedmsg.com/en/latest/topics/#id34>`_.  The docs there show:

- The topic.
- Some description of the event.
- An example message in JSON format.  This is what you would see if you
  ran ``$ fedmsg-tail --really-pretty``.
- Some description of what you would get if you passed the example message
  into some of the functions in the `fedmsg.meta
  <http://www.fedmsg.com/en/latest/meta/>`_ python module.  This is the stuff
  you see in the ``#fedora-fedmsg`` irc channel and on the `identi.ca bot
  <http://identi.ca/fedmsgbot>`_.

Just in case you didn't know, you can listen to the public fedmsg bus
(with no configuration) by running::

    $ sudo yum install fedmsg
    $ fedmsg-tail --really-pretty

If you want to program something that responds to fedmsg messages,
check out the docs on `consuming messages from python
<http://www.fedmsg.com/en/latest/topics/>`_ -- the new list of topics
should come in handy.
