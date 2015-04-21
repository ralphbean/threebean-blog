---
categories: fedora, pycon, python
date: 2015/04/21 10:05:00
permalink: http://threebean.org/blog/pycon-2015-part-ii
title: PyCon 2015 (Part II)
---

I `wrote last week <http://threebean.org/blog/pycon-2015-part-i>`_ about how
a `few of us from Fedora <https://fedoraproject.org/wiki/PyCon_2015>`_ were at
PyCon US in Montreal for the week.  It's all over and done with and we're back
home now (I got a flu-like bug for the second time this season on the way home...)
So, these are just some quick notes on what I did at the `sprints
<https://us.pycon.org/2015/community/sprints/>`_!

- Early on, I `ported python-fedora to python3
  <https://github.com/fedora-infra/python-fedora/pull/117>`_ and afterwards
  `bkabrda <https://bkabrda.wordpress.com/>`_ picked up the torch and ported
  fedmsg and the expansive fedmsg_meta module.  The **one** thing standing in
  the way of full-on python3 fedmsg is the M2Crypto library which will probably
  not see python3 compatibility anytime soon.  Slavek courageously ported half
  of fedmsg's crypto stack to the python3-compatible `cryptography
  <https://pypi.python.org/pypi/cryptography>`_ library only to find that it
  didn't support the other half of the equation.  We're keeping those changes
  in a branch until that gets caught up.

- The most exciting bit was helping `Nolski <https://nolski.rocks/>`_ with his
  `tool that puts fedmsg notifications on the OSX desktop
  <https://pypi.python.org/pypi/xmsg>`_.  It totally works.  Crazy, right?

- Later in the week, I helped `decause <http://decausemaker.org/>`_ a bit with
  his new `cardsite app <http://decause.github.io/cardsite/>`_.  Load it up and
  let it run for a while.  It's yet another neat way to visualize the activity
  of the Fedora community in realtime.

- I started a `prototype of fedora-hubs
  <https://github.com/ralphbean/fedora-hubs-prototype>`_ which doesn't do much
  but display little dummy widgets, but it is useful for reflecting on how the
  architecture ought to work.

- I wrote `some code <https://github.com/fedora-infra/fedmsg-notify/pull/20>`_
  to get the fedmsg-notify desktop tool to pull its preferences from the `FMN
  service <https://apps.fedoraproject.org/notifications>`_.  The changes work, but
  they required some server-side patches to FMN that are done, but haven't yet
  been rolled out to production (and we're in freeze for the Beta release
  anyways..).

  In order to use your FMN preferences, you currently have to set a
  ``gsettings`` value by hand which is unacceptable and gross, but I'm not sure
  how to present it in the config UI.  We can't just go *all-in* with FMN
  because there are other distros out there (Debian) which use fedmsg-notify
  but which don't run their own FMN service.  We'll have to think on it and let
  it sit for a while.

- Lastly, Bodhi2 saw some good work.  (We fixed some bugs that needed to be
  hammered out before release and we actually have an RPM and installed it on a
  cloud node!  Staging will be coming next once some el7 compat deps get sorted
  out.)

- `ncohglan <https://twitter.com/ncoghlan_dev>`_ introduced us to the authors of
  `kallithea <https://kallithea-scm.org/>`_ which led to some conversations about
  `pagure <https://pagure.org/>`_ and where we can collaborate.

- I was really glad to meet `sijis <https://github.com/sijis>`_ for fun-time
  late-night hackery in the hotel lobby.

That's all I can remember.  It was a whirlwind, as always.  Happy Hacking!
