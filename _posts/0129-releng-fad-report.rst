---
categories: fedora, releng, koji
date: 2015/06/15 15:30:00
permalink: http://threebean.org/blog/releng-fad-report
title: Some notes from the releng FAD
---

A number of us were funded to come together last weekend for a `release
engineering FAD
<https://fedoraproject.org/wiki/FAD_Release_Tools_and_Infrastructure_2015>`_ in
Westford.  I'll save summaries of the whole event for writeups by others, but I
will say that we planned work on the first day with an 'agile' exercise
proposed and facilitated by `imcleod
<https://badges.fedoraproject.org/user/imcleod>`_.  It worked well and
mitigated any centrifugal forces acting on the FAD.

Read `Adam Miller's post
<http://pseudogen.blogspot.com/2015/06/fedora-activity-day-release-engineering.html>`_
for a solid summary of the whole event.  Here's just a run down of the things I
personally got involved in:

- The **runroot plugin** - we've been talking about it *forever* -- an Internet
  search reveals a mention of it from `a meeting in 2007
  <http://fedoraproject.org/wiki/Extras/SteeringCommittee/Meeting-20070315>`.
  What finally made it a necessity is ``pungi4``.  We're hoping to move the
  compose to using that, and *it* in turn relies on the runroot plugin in koji
  to do most of its work.

  A portion of it was open sourced last year.  I got it installed in staging
  and then found we were missing some more parts to it.  We sorted those all
  out, submitted some patches upstream to koji and got a staging proof of
  concept working.  As of last week, we have it in production and a `new
  channel of builders
  <http://koji.fedoraproject.org/koji/channelinfo?channelID=9>`_ dedicated to
  it.

- Our **staging koji** instance was originally setup last year at the Bodhi2
  FAD using the *external repos* feature of koji.  This worked well enough for
  testing scratch builds and little things like that, but was insufficient for
  testing some larger parts of the releng process (the compose).
  We compared `some options
  <https://lists.fedoraproject.org/pipermail/infrastructure/2015-June/016377.html>`_
  and have settled on a solution.  Some pieces of that puzzle have been
  implemented but I've yet to finish putting it all together.  Hopefully done
  this week.

- As far as planning goes, I thought the **koji 2.0** discussions were quite
  fruitful, and I'm really excited at how the architecture it shaping up.

- We also had some good interstitial sessions talking about role and
  requirements for what has been heretofore called the ComposeDB.
  There's still more discussion to have before we can land on a planning
  document for it, but fwiw, we think we have a much better name for it than
  ComposeDB.

I'll end with noting that on the day before the FAD started, a number of us got
together to plan for and hack on `Fedora Hubs
<https://fedoraproject.org/wiki/Fedora_Hubs>`_.  `decause
<https://fedoraproject.org/wiki/User:Decause>`_ and I stayed up late almost
every night and wrote some pretty neat proofs of concept for it.  There's good
stuff running now in `the prototype <https://pagure.io/fedora-hubs>`_ if you
want to try to get it running on your local system.  Fun, fun.  Happy Hacking!
