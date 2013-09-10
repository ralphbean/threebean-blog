---
categories: fedora, badges
date: 2013/09/10 09:05:00
permalink: http://threebean.org/blog/fedora-badges-optimizations
title: Fedora Badges Optimizations
---

The latest release of `tahrir <https://github.com/fedora-infra/tahrir>`_ (the
`Fedora Badges <https://badges.fedoraproject.org>`_ web frontend) includes a
parade of optimizations.  In my local tests, almost all page loads are **50
times faster**.

As the number of users and badges in the system grew, performance got worse and
worse.  There were some so-called ``n+1`` queries in there where page loads
would scrape over the whole DB counting everyone's badges before responding.

That stuff has been removed; the badges site should be much snappier now (same
goes for the the JSON API employed by `Fedora Mobile
<https://fedoraproject.org/mobile>`_).
