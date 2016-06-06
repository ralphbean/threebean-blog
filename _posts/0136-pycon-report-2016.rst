---
categories: fedora, pycon, python
date: 2016/06/06 19:00:00
permalink: http://threebean.org/blog/pycon-report-2016
title: PyCon Report, 2016
---

Like in `previous <http://threebean.org/blog/pycon-2015-part-i>`_ `years
<http://threebean.org/blog/pycon-2015-part-ii>`_, a `few of us from Fedora
<https://fedoraproject.org/wiki/PyCon_2016>`_ were at PyCon US in Portland
Oregon for the week.  The conference is over now (I'm sticking around for a day
to explore the Pacific Northwest).  Here are some of the highlights from the
talks attended and the `community sprint days
<https://us.pycon.org/2016/community/sprints/>`_:

**Talks worth checking out**

- K Lars Lohn's `final keynote <https://www.youtube.com/watch?v=bSfe5M_zG2s>`_
  was out of control.  None of us were ready for it.  It wasn't even about
  python but I know everyone loved it.  Parisa Tabriz's `keynote on hacker
  mindset <https://www.youtube.com/watch?v=kxqci2mZdrc>`_ was very good (she's
  the "security princess" at Google) and Guido van Rossum's `keynote on the
  state of python <https://www.youtube.com/watch?v=YgtL4S7Hrwo>`_ wandered off
  into an interesting autobiography about what made Python possible.  If you're
  interested in software architecture, the Wednesday morning `keynote on Plone
  and Zope <https://www.youtube.com/watch?v=eGRJbBI_H2w>`_ by `@cewing
  <https://github.com/cewing>`_ was an interesting overview of the evolution of
  that stack.
- Alex Gaynor's talk on automation for dev groups, cleverly titled `"The
  cobbler's children have no shoes"
  <https://www.youtube.com/watch?v=gRFHvavxnos>`_ was `close to my heart
  <github.com/ralphbean/bugwarrior>`_.  There was a salient point in the Q&A
  section about how while we often focus on automating workflows that are
  somehow problematic, sometimes that problem is a deeper social one.
  Automation can surface and inadvertantly exacerbate a tension between groups
  that have friction.
- For web development stuff, three talks are worth highlighting: `@callahad
  <https://twitter.com/callahad>`_ of Mozilla (who is an awesome person) gave a
  talk on new mobile web technologies, `Service Workers, Push, and App
  Manifests <https://www.youtube.com/watch?v=dacOIIqKFfs>`_.  It's worth a
  listen for people in the Fedora and Red Hat infrastructure ecosystem.
  `@dshafik <https://twitter.com/dshafik>`_ of Akamai gave a *super*
  interesting talk on `HTTP/2 and the consequences for web devs
  <https://www.youtube.com/watch?v=Mou17XxYRZk>`_.  The short of it is that we
  have all these hacks in place that have become "best practice" over the years
  (sprite sheets, compressed and concatenated assets, bloated collection REST
  responses), none of which are necessary or desirable when we have HTTP/2
  ready to go server-side.  Sixty percent of browsers are ready to consume
  HTTP/2 apps and its all backwards compatible.  Definitely worth looking into.
  Last but not least, if you do wev development, check out `Sumana's
  <https://www.harihareswara.net/>`_ talk titled `"HTTP can do that?!"
  <https://www.youtube.com/watch?v=HsLrXt2l-kg>`_ which goes over how to get
  the most out of HTTP/1 (something we've not always been the best at doing) --
  very engaging.
- If you watch *any* of the talks here, check out `Larry Hasting's
  <http://www.larryhastings.com/>`_ talk on `removing python's global
  interpreter lock <https://www.youtube.com/watch?v=P3AyI_u66Bw>`_.  It's
  important if you use the language, deal with performance issues, and
  especially if you write C extensions.  If none of those are you -- the
  details of the interpreter implementation are still super interesting.
  ``#gilectomy``
- Of course the **hallway track** was the most valuable.  I had good talks with
  `@goodwillbits <https://twitter.com/goodwillbits>`_, `@lvh
  <https://twitter.com/lvh>`_, `@sils1297 <https://github.com/sils1297>`_, and
  too many others to mention.

For the **community code sprints**, I hacked with a couple other people on the
test suite for `koji <https://pagure.io/koji>`_ which is the build system used
by Fedora and many other RPM-based Linux distributions.  We have a lot of web
services and systems that go into producing the distro.  Koji was one of the
first that was written back in the day and it is starting to show its age.
Getting test coverage up to a reasonable state is a pre-requisite for further
refactoring (porting to python3, making it more modular, faster, etc..).

- https://pagure.io/koji/pull-request/93
- https://pagure.io/koji/pull-request/94
- https://pagure.io/koji/pull-request/95
- https://pagure.io/koji/pull-request/96
- https://pagure.io/koji/pull-request/98
- https://pagure.io/koji/pull-request/99
- https://pagure.io/koji/pull-request/100
- https://pagure.io/koji/pull-request/101
- https://pagure.io/koji/pull-request/102
- https://pagure.io/koji/pull-request/103
- https://pagure.io/koji/pull-request/104
- https://pagure.io/koji/pull-request/105
- https://pagure.io/koji/pull-request/106
- https://pagure.io/koji/pull-request/107
- https://pagure.io/koji/pull-request/108

**Huge shoutout** to `Sijis Aviles <https://github.com/sijis>`_, `Joel Vasallo
<http://joelvasallo.com/>`_, and `Robert Belozi <https://twitter.com/belozi>`_
for slogging through it with me.  We had fun!
