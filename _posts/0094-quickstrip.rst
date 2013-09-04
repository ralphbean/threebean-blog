---
categories: fedora, python, nitpicking
date: 2013/09/03 11:30:00
permalink: http://threebean.org/blog/quickstrip
title: A tiny optimization
---

Talking over a `pull request
<https://github.com/fedora-infra/fedmsg/pull/183#discussion_r6128422>`_ with
`@pypingou <https://github.com/pypingou>`_, we found that this one method of
constructing a ``set`` from a list of stripped strings was slightly faster than
another::

    #!python
    #!/usr/bin/env python
    """ Timing stuff.

    ::
        $ python timeittest.py
        set(map(str.strip, ['wat '] * 200))
        30.9805839062
        set([s.strip() for s in ['wat '] * 200])
        31.884624958
    """

    import timeit


    def measure(stmt):
        print stmt
        results = timeit.timeit(stmt)
        print results


    measure("set(map(str.strip, ['wat '] * 200))")
    measure("set([s.strip() for s in ['wat '] * 200])")

Admission:  Pierre bullied me into blogging about this!

----

**UPDATE**: Folks in the comments recommended using a generator or
``itertools.imap``.  The results are *significantly* better.  Here they are::

    import itertools; [s.strip() for s in ['wat '] * 200]
    28.2224271297
    import itertools; (s.strip() for s in ['wat '] * 200)
    3.0280148983
    import itertools; map(str.strip, ['wat '] * 200)
    25.7294211388
    import itertools; itertools.imap(str.strip, ['wat '] * 200)
    2.3925549984

----

**UPDATE (again)**: Comments further reveal that the update above is misleading
-- the generators aren't actually doing any work there.  If we force them to
spin out, we get results like these::

    import itertools; set([s.strip() for s in ['wat '] * 200])
    33.4951019287
    import itertools; set((s.strip() for s in ['wat '] * 200))
    35.5591659546
    import itertools; set(map(str.strip, ['wat '] * 200))
    33.7568879128
    import itertools; set(itertools.imap(str.strip, ['wat '] * 200))
    35.9931280613

No clear benefit for use of ``imap`` or generators.
