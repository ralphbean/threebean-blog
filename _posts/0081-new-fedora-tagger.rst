---
categories: fedora, tagger
date: 2013/05/13 23:30:00
permalink: http://threebean.org/blog/new-fedora-tagger
title: The New Fedora Tagger
---

Last week the infrastructure team launched a new version of the `Fedora Tagger
<https://apps.fedoraproject.org/tagger/>`_.  It is a webapp that allows
users to upvote/downvote tags on packages as well as rate packages themselves.
The data ends up getting pulled into yum repo metadata by the bodhi masher
and into the `Fedora Packages <https://apps.fedoraproject.org/packages/>`_
indexer to improve search results.  Fedora Tagger is also one of our first
attempts at "gamification".  You earn "points" by voting and rating and
there's a leaderboard on which you can muscle for first place(!)

This new version is quite a bit of a rewrite.  The original version
was written on top of the TurboGears2 framework; this new one is
written on Flask instead.

The rewrite has given us an opportunity to more clearly define `the API
<https://apps.fedoraproject.org/tagger/api/v1/>`_ (thanks to the hard efforts
of `Pierre-Yves Chibon <http://blog.pingoured.fr/>`_).  This affords us
the opportunity to write tools
against it:  Pierre is working on a `desktop tagger application
<http://blog.pingoured.fr/index.php?post/2013/03/27/GNOME-tagger>`_ and we've
been in some conversation with `Richard Hughes
<https://blogs.gnome.org/hughsie/>`_ about using it for `gnome-software
<http://blogs.gnome.org/hughsie/2013/03/05/gnome-software-overall-plan/>`_.

Aside from having such a `documented API
<https://apps.fedoraproject.org/tagger/api/v1/>`_, there are new end-user
features and bugfixes, including:

- OpenID FAS Login for security and convenience.
- You can now cast your rating on packages (not just tags on packages)
- The scoring system is more complicated.  Adding new tags is worth more
  points than voting on pre-existing tags.
- `oddshocks <http://oddshocks.com/about/>`_ contributed a nice link to the
  bug tracker from the main page.
- After `some deliberation
  <https://github.com/fedora-infra/fedora-tagger/issues/65>`_ on how to
  go about it, you can actually view packages with no tags when anonymous now.
- There used to be some weird focus-stealing bugs when using hotkeys.  Those
  have been eliminated.

`Try it out <https://apps.fedoraproject.org/tagger/>`_, help improve package
search, and climb your way to the number-one tagger spot!
