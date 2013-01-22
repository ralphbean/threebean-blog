---
categories: fudcon, fedora, fedmsg
date: 2013/01/22 13:00:00
permalink: http://threebean.org/blog/fudcon-lawrence
title: FUDCon Lawrence
---

Back in Rochester after a wild ride at FUDCon.  Here's a rundown of my
participation (`deets
<http://threebean.org/timesheets/2013-01-21.html>`_):

- Gave a lightning talk on pkgwat and a session on fedmsg.
- Worked out an API design for `datagrepper
  <https://github.com/fedora-infra/datagrepper>`_ with `Ian Weller
  <http://blog.ianweller.org/>`_.
- Figured out a mechanism for end users to validate incoming fedmsg
  messages talking with `Luke Macken <http://lewk.org>`_.
- `Toshio <https://fedoraproject.org/wiki/User:Toshio?rd=ToshioKuratomi>`_
  and I brought `pkgdb <http://admin.fedoraproject.org/pkgdb>`_ into
  the fedmsg brood.
- It's been a long time coming, but I updated fedmsg in our production
  environment to be using zeromq3's TCP_KEEPALIVE features.  We'll see if this
  solves our message dropping problem.
- We moved a new release of the `/packages webapp
  <https://apps.fedoraproject.org/packages>`_ to production which includes my
  `dogpile.cache <http://dogpilecache.readthedocs.org/en/latest/>`_ work.
- `Jordan Sissel <http://www.semicomplete.com/>`_ remotely hooked fedmsg up
  to `the logstash demo <http://bit.ly/XwKqY9>`_.
- Talked with `Dennis Gilmore
  <https://fedoraproject.org/wiki/User:Ausil?rd=DennisGilmore>`_ about hooking
  koji up to fedmsg.  We have a plan and it shouldn't be too much longer.
  Getting messages out of koji was the #1 request I heard at FUDCon.
- Also talked with Dennis about getting fedmsg messages out from secondary arch
  composes (the `rel-eng process
  <http://fedoraproject.org/wiki/ReleaseEngineering>`_) and with `Seth Vidal
  <http://skvidal.wordpress.com/>`_ about getting fedmsg messages out from
  `copr <http://fedoraproject.org/wiki/Category:Copr>`_ and our private cloud.
  Both situations require bringing messages in from untrusted environments and
  so will require some new measures.  Plan++.
- Lots of discussion about `Fedora Badges
  <http://fedoraproject.org/wiki/Open_Badges>`_ (the stack for which needs a
  lot of love).  I'll
  be buckling down more on it once I finish the current phase of fedmsg, but
  having the discussions out about infrastructure, goals, and scope with the
  whole group was a good thing.
- Some good bar-time discussion of the `GNOME OPW <https://gnome.org/opw>`_
  and how to make it more effective!
- Met `pingou <http://blog.pingoured.fr/>`_, the French crew, and really
  everyone else.  The Fedora community is full of some pretty awesome people.
  ``:)``
