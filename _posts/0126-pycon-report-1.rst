---
categories: fedora, pycon, python
date: 2015/04/12 11:00:00
permalink: http://threebean.org/blog/pycon-2015-part-i
title: PyCon 2015 (Part I)
---

A `few of us from Fedora <https://fedoraproject.org/wiki/PyCon_2015>`_ are at
PyCon US in Montreal for the week.  The conference portion is almost over and
the sprints start tomorrow, but in the meantime here are some highlights from
the **best sessions I sat in on**:

- `@nnja <https://twitter.com/nnja>`_ gave a great talk on `technical debt and
  how it can contribute to a "culture of despair"
  <https://www.youtube.com/watch?v=JKYktDRoRxw>`_.

- `@sigmavirus24's <https://twitter.com/sigmavirus24>`_ talk on `writing tests
  against python-requests <https://www.youtube.com/watch?v=YHbKxFcDltM>`_ was
  supremely useful.  Using his material, I wrote a patch for anitya that solved
  an `onerous and recurring issue with the test suite
  <https://github.com/fedora-infra/anitya/issues/120>`_.

- You've just got to see `this talk on pypy.js
  <https://www.youtube.com/watch?v=PiBfOFqDIAI>`_.  In short, he used llvm to compile
  pypy into javascript so it can run in the browser (with asm.js) which runs
  *faster than CPython*, amazingly.

- Raymond Hettlinger gave a very nice talk on "moving beyond pep8" which was
  pretty relevant for my team and our code review practices.  We write *a lot*
  of code which entails doing *a lot* of code review.  His thesis:  working in
  a cosmetic pep8 mindset causes you to often *miss the elephant in the room*
  when doing code review.  Instructive.

- There was a very good talk on one particular company's experiences with a
  microservices architecture.  It is of special interest to me and our work on
  the Fedora Infrastructure team with lots of good take-aways.  The video of
  it hasn't been posted yet, but definitely search for it in the coming days.

- I quite disagreed with some of the method presented in the `effective python
  session <https://www.youtube.com/watch?v=WjJUPxKB164>`_.  No need for
  wrapper-class boilerplate -- just use ``itertools.tee(...)``!

- Some others:  `distributed systems theory
  <https://www.youtube.com/watch?v=YAFGQurdJ3U>`_, `interpreting your genome
  <https://www.youtube.com/watch?v=jV4YMQHZmMk>`_, `systems stuff for
  non-systems people <https://www.youtube.com/watch?v=5v6o-VsLAew>`_, and
  `ansible <https://www.youtube.com/watch?v=igJTEugHozM>`_ were all very nice.

**Some hacking happened** in the interstitial periods!

- I wrote `a prototype <https://github.com/fedora-infra/statscache>`_ of a system
  to calculate and store statistics about fedmsg activity and `some plugins for it
  <https://github.com/fedora-infra/statscache_plugins>`_.  This will hopefully
  turn out to be quite useful for building community dashboards in the future
  (like a revamped `releng dashboard <https://apps.fedoraproject.org/releng-dash>`_
  or the nascent `fedora-hubs
  <http://blog.linuxgrrl.com/2015/03/24/enabling-new-contributors-brainstorm-session/>`_).

- We `ported python-fedora to python3!
  <https://github.com/fedora-infra/python-fedora/pull/117>`_  Hooray!

- The GSOC deadline really snuck up on us, so Pierre-Yves Chibon and I carved
  out some time to sit down and go over all the pending applications.

I'm really looking forwards to the sprints and the chance to work and connect
with all our upstreams.  We'll be holding a "Live From Pycon" video cast at
some point.  Details forthcoming.  Happy Hacking!

