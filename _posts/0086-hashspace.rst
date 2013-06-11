---
categories: python, fedmsg, aosa, fedora
date: 2013/06/10 21:30:00
permalink: http://threebean.org/blog/hashspace
title: Distributing jobs via hashmaths
---

As things stand, we can't load balance across multiple ``fedmsg-hub`` daemons
(We can and do balance across multiple ``fedmsg-gateway`` instances, though --
that is another story).

For the hubs though, here's a scheme that might work.  However.. is it
fast enough?

::

    #!python
    #!/usr/bin/env python
    """ Distribute jobs via.. "hashspace"?

    Actually give this a run.  See what it does.

    I learned about it from the mailman3 chapter in AOSA
    http://www.aosabook.org/en/mailman.html
    """

    import json
    import hashlib


    class Consumer(object):

        def __init__(self, i, n):
            self.i = i
            self.n = n

        def should_I_process_this(self, msg):
            """ True if this message falls in "our" portion of the hash space.

            This seems great, except I bet its pretty expensive.

            Can you come up with an equivalent, "good enough" method that is
            more efficient?
            """
            as_a_string = json.dumps(msg)
            as_a_hash = hashlib.md5(as_a_string).hexdigest()
            as_a_long = int(as_a_hash, 16)
            return (as_a_long % self.n) == self.i


    def demonstration(msg):
        """ Handy printing utility to show the results """"

        print "* Who takes this message? %r" % msg
        for consumer in consumers:
            print "  *", consumer.i, "of", consumer.n, "hubs.",
            print "  Process this one?", consumer.should_I_process_this(msg)

    if __name__ == '__main__':
        # Say we have 4 moksha-hubs each running the same set of consumers.
        # For story-telling sake, we'll say we're dealing here with the datanommer
        # consumer.  Let's pretend it has to do some heavy scrubbing on the message
        # before it throws it in the DB, so we need to load-balance that.

        # As things stand now with fedmsg.. we can't do that *hand waving*.
        # This is a potential scheme to make it possible.

        # We have 4 moksha-hubs, one on each of 4 machines.
        N = 4
        consumers = [Consumer(i, N) for i in range(N)]

        # Fedmsg delivers a message.  All 4 of our hubs receive it.
        # They each take the md5 sum of the message, convert that to a long
        # and then mod that by the number of moksha-hubs.  If that remainder is
        # *their* id, then they claim the message and process it.
        demonstration(msg={'blah': 'I am a message, lol.'})
        demonstration(msg={'blah': 'I am a different message.'})
        demonstration(msg={'blah': 'me too.'})

        # Since md5 sums are "effectively" random, this should distribute across
        # all our nodes mostly-evenly.

As I was typing this post up, `Toshio Kuratomi
<http://anonbadger.wordpress.com/>`_ mentioned that I should look into
`zlib.adler32 <http://docs.python.org/2/library/zlib.html#zlib.adler32>`_ and
`binascii.crc32
<http://docs.python.org/2/library/binascii.html#binascii.crc32>`_ if I am
concerned about speed (which I am).

Perhaps some benchmarking is in order?
