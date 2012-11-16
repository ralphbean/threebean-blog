---
categories: python, fedora, fedmsg, zeromq
date: 2012/11/16 16:00:00
permalink: http://threebean.org/blog/zeromq-and-fedmsg-diy
title: Ømq and fedmsg DIY
---

`Bill Peck <https://github.com/p3ck/>`_ wanted to know if he could consume
messages from the `Fedora Infrastructure message bus <http://fedmsg.rtfd.org>`_
without using the fedmsg libs and stack.  The answer is yes.

I wrote up an example for him and turns out it was pretty simple, simple enough
to warrant `being added as its own new section in the docs
<http://fedmsg.readthedocs.org/en/latest/consuming/#diy-listening-with-raw-zeromq>`_.

The downshot here is that you don't get the configuration helpers of
``fedmsg.config``, the message manipulation helpers of ``fedmsg.text`` and most
importantly, the message validation of ``fedmsg.crypto``.  The upshot is that
you get a quick connection without all those dependencies::

    #!python
    #!/usr/bin/env python
    """ You'll need to install python-zmq (pyzmq) for this one.. """

    import json
    import pprint
    import zmq


    def listen_and_print():
        # You can listen to stg at "tcp://stg.fedoraproject.org:9940"
        endpoint = "tcp://hub.fedoraproject.org:9940"
        # Set this to something like org.fedoraproject.prod.compose
        topic = 'org.fedoraproject.prod.'

        ctx = zmq.Context()
        s = ctx.socket(zmq.SUB)
        s.connect(endpoint)

        s.setsockopt(zmq.SUBSCRIBE, topic)

        poller = zmq.Poller()
        poller.register(s, zmq.POLLIN)

        while True:
            evts = poller.poll()  # This blocks until a message arrives
            topic, msg = s.recv_multipart()
            print topic, pprint.pformat(json.loads(msg))

    if __name__ == "__main__":
        listen_and_print()

----

p.s., in other news `Amit Saha
<https://fedoraproject.org/wiki/User:Amitksaha>`_ has `a post
<http://echorand.me/2012/11/16/mining-the-fedora-infrastracture-bus/>`_ up
on collecting stats from the fedmsg bus.  This is exciting to me.
