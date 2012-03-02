---
categories: python, toscawidgets, turbogears, pyramid
date: 2012/03/02 11:00:00
permalink: http://threebean.org/blog/the-final-countdown
title: TW2 Bugsprint; the Final Countdown
---

Tomorrow marks the start of the `toscawidgets2 24 hour bugsprint
<http://threebean.org/blog/announcing-tw2-bugsprint>`_ and I couldn't be more
stoked.  We haven't even started yet but tw2 development pushed ahead anyways.

We have:

  - redesigned the `tw2 homepage
    <http://threebean.org/blog/new-tw2-frontpage/>`_.
  - improved tw2.jqplugins.jqgrid's `sqlalchemy integration
    <https://github.com/ralphbean/tw2.jqplugins.jqgrid/pull/4>`_.
  - pumped out `one <https://github.com/ralphbean/tw2.jqplugins.ui/issues/8>`_
    or `two <https://github.com/ralphbean/tw2.jqplugins.ui/issues/9>`_
    miscellaneous fixups to tw2.jqplugins.ui.

    - This includes `fixing the
      grievously broken support for certain alternate themes
      <https://github.com/ralphbean/tw2.jqplugins.ui/issues/7>`_.

  - released `tw2.jqplugins.elrte
    <http://pypi.python.org/pypi/tw2.jqplugins.elrte>`_.
  - released `tw2.jqplugins.elfinder
    <http://pypi.python.org/pypi/tw2.jqplugins.elrte>`_ (which is amazing).
  - released `tw2.captcha <http://pypi.python.org/pypi/tw2.captcha>`_ based on
    `tgcaptcha2`.
  - released an alpha version of `tw2.d3 <http://pypi.python.org/pypi/tw2.d3>`_.
    It's built with WebSocket support in mind.  More on that soon!
  - been excited to learn that the `TurboGears2 team is aiming to
    standardize on tw2
    <https://groups.google.com/forum/?fromgroups#!topic/turbogears/N1xh_r0Sjt4>`_.
  - been fielding a lot more support for tw2 in `Pyramid 1.3
    <http://pypi.python.org/pypi/pyramid>_` both on the mailing list and in
    ``#toscawidgets``.  There's a bug still lurking out there for
    `windows+tw2+pyramid users
    <https://bitbucket.org/paj/tw2core/issue/108/working-with-latest-pyramid-13>`_.
    At this point, if you can reproduce it and tell us about it, that would
    be helpful.

**Goal:** (solidly) close as many bugs as possible and push as many libraries
from beta to release as we can.

Here's to winning that game.
