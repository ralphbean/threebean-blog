---
categories: python, toscawidgets, turbogears, pyramid
date: 2012/03/04 15:00:00
permalink: http://threebean.org/blog/bugsprint-report
title: ToscaWidgets2 Bugsprint Report
---

Here's the rundown of the `pre-PyCon tw2 bugsprint
<http://threebean.org/blog/announcing-tw2-bugsprint>`_.  The unstoppable `Greg
Jurman <https://github.com/gregjurman>`_ and I coordinated in google+ and IRC
(with lots of ad-hoc visitors in both) and did all the damage we could do to the
`bug list <http://bitbucket.org/paj/tw2core/issues>`_.  Our goal was to close
enough that we could justify a solid 2.0 non-beta release but we didn't quite
get there.  We settled on `2.0 release candidate 1
<http://pypi.python.org/pypi/tw2.core/2.0rc1>`_.

**tl;dr** - Big progress.  We'll seal the deal on 2.0 at PyCon US next week.

Infrastructure:

 - tw2 sourcecode is spread out in repos all over the place.  We centralized
   *everything* at http://github.com/toscawidgets.
 - We're using `git-flow <http://github.com/nvie/gitflow>`_ to manage
   team development and releases.
 - We setup a http://cia.vc bot in #toscawidgets/IRC, which is awesome.
 - We're in the continuous integration queue with `Shining Panda
   <https://www.shiningpanda.com/>`_.

Tickets closed:

 - `Duplicated TW Encoders
   <https://bitbucket.org/paj/tw2core/issue/92>`_
 - `Graceful degradation when JS disabled for tw2.dynforms
   <https://bitbucket.org/paj/tw2core/issue/71>`_
 - `HTML5 Prompt Text
   <https://bitbucket.org/paj/tw2core/issue/53>`_
 - `Configurable 'location' for resources
   <https://bitbucket.org/paj/tw2core/issue/95>`_
 - `Disable resource injection on a per-resource basis
   <https://bitbucket.org/paj/tw2core/issue/94>`_
 - `Document middleware configuration values
   <https://bitbucket.org/paj/tw2core/issue/96>`_
 - `Handling SCRIPT_NAME
   <https://bitbucket.org/paj/tw2core/issue/77>`_
 - `Internationalization
   <https://bitbucket.org/paj/tw2core/issue/97>`_
 - `Inline templates
   <https://bitbucket.org/paj/tw2core/issue/69>`_
 - `Refactor resources for better compatibility with tw0.9
   <https://bitbucket.org/paj/tw2core/issue/5>`_
 - `Automatic 'modname' for resources
   <https://bitbucket.org/paj/tw2core/issue/14>`_
 - `Shortcuts for controller registration / Tidy up tutorial
   <https://bitbucket.org/paj/tw2core/issue/88>`_

Tickets worked on, but not complete:

 - `Make onload trigger onchange
   <https://bitbucket.org/paj/tw2core/issue/31>`_
 - `Growing grid - no label
   <https://bitbucket.org/paj/tw2core/issue/44>`_
 - `Problems with colons as id separators
   <https://bitbucket.org/paj/tw2core/issue/7>`_
 - `Refactor controller widgets
   <https://bitbucket.org/paj/tw2core/issue/67>`_
 - `Consider "crank"
   <https://bitbucket.org/paj/tw2core/issue/107>`_
 - `Enhanced widgetbrowser
   <https://bitbucket.org/paj/tw2core/issue/66>`_

Tickets created:

 - `Refactor the entire templates system
   <https://bitbucket.org/paj/tw2core/issue/109>`_

