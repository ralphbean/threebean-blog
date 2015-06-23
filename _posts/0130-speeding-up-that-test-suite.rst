---
categories: fedora, fedmsg, python, nose
date: 2015/06/23 10:30:00
permalink: http://threebean.org/blog/speeding-up-that-test-suite
title: Speeding up that nose test suite.
---

Short post:  I just discovered the ``--with-prof`` option to the ``nosetests``
command.  It profiles your test suite by using the ``hotshot`` module from the
Python standard library and it found a huge sore spot in my most frequently run
suite. In `this pull request
<https://github.com/fedora-infra/fedmsg/pull/341>`_ we got the `fedmsg_meta
<https://github.com/fedora-infra/fedmsg_meta_fedora_infrastructure/>`_ running
**31x** faster.

Compare before::

    (fedmsg_meta)❯ time $(which nosetests) -x
    Ran 3822 tests in 270.822s

    OK (SKIP=1638)
    ----------------------------------------------------------------------
    Success!
    $(which nosetests) -x  267.30s user 1.32s system 98% cpu 4:33.53 total

And after::

    (fedmsg_meta)❯ time $(which nosetests) -x
    Ran 3822 tests in 5.982s

    OK (SKIP=1638)
    ----------------------------------------------------------------------
    Success!
    $(which nosetests) -x  3.87s user 0.71s system 52% cpu 8.700 total

That test suite used to take *forever*.  It's the whole reason I wrote
`nose-audio <https://pypi.python.org/pypi/nose-audio>`_ in the first place!
