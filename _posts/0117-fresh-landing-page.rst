---
categories: fedora
date: 2014/09/29 09:45:00
permalink: http://threebean.org/blog/fresh-landing-page
title: Facelift for the apps.fp.o landing page
---

The `apps.fp.o landing page <https://apps.fedoraproject.org>`_ got an update
last week:

It was **reorganized** -- the categories in place before weren't thought out
that well, and we had started to out-grow them.  I reorganized the apps loosely
by "purpose".  If you have input and want to suggest changes, please do `file a
bug <https://github.com/fedora-infra/apps.fp.o>`_ or submit a patch.

It got a **fresh theme** -- I updated the css from old ``bootstrap-2.x``
conventions to ``bootstrap-3.1.x`` and am now using our Fedora bootstrap theme
-- the same css base that `FMN <https://apps.fedoraproject.org/notifications>`_
and `bodhi2 <http://threebean.org/blog/bodhi2-karma-system-preview/>`_ use.

It now has **status integration** -- some apps on the landing page now draw
additional information from `status.fp.o <https://status.fedoraproject.org>`_
to give viewers a heads up if they're not functioning correctly.

.. image:: https://camo.githubusercontent.com/c4bc07d4fa66d99424a70301afa2dde3effe77f5/687474703a2f2f74687265656265616e2e6f72672f636c65616e65722d617070732e66702e6f2e706e67
   :width: 645px
   :target: https://apps.fedoraproject.org/

`gnokii <http://karl-tux-stadt.de/ktuxs/>`_ tells me he uses this thing all the
time in his "how to join Fedora" sessions since "nobody can remember all the
different urls."
