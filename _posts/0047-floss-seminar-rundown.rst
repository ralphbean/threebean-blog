---
categories: python, turbogears, teachingopensource, openshift
date: 2012/03/06 18:00:00
permalink: http://threebean.org/blog/floss-seminar-rundown
title: Teaching Open Source, Web-Based, Game Programming at RIT
---

This last `quarter
<http://www.rit.edu/emcs/admissions/bca/blog/item/academic-quarters>`_ at `RIT
<http://www.rit.edu>`_ I taught (for the first time) a `course on open source,
web-based, game programming <http://ritfloss.rtfd.org>`_.  The quarter just came
to an end and I really want to brag on my students.  But before I do that,
here's a glimmer of what we covered:

 - How to use bash and vim
 - How to use git and github
 - How to submit patches to projects you know nothing about
 - What makes a good, `casual game
   <http://www.amazon.com/Casual-Game-Design-Designing-Gamer/dp/0123749530>`_
 - How to make `games with HTML5
   <http://www.amazon.com/Making-Isometric-Social-Real-Time-Javascript/dp/1449304753>`_
 - How to program in JavaScript, CoffeeScript, and Python
 - Serverside programming with `Turbogears2 <http://turbogears.org>`_
 - How to get your code running on Red Hat's `Openshift
   <http://openshift.redhat.com>`_ cloud.
 - How to give a lightning talk(!)

Really cool stuff was built into the class; it was about making open source
software, so we `open sourced the syllabus
<http://ritfloss.readthedocs.org/en/latest/hw/fflight.html#patch-the-course-project>`_!
Really cool stuff happened along the way; we hit ugly problems with openshift,
so we `patched the quickstarter script
<https://github.com/lmacken/turbogears2-openshift-quickstart/commits/>`_!

You can endure my self-indulgent drivel yes, but you get the best picture from
reading the `students' blog posts <http://threebean.org/floss-planet>`_
themselves.  Enough of this!  `Les projets de cours`!

----

**#1** - `Lazorz <http://lazorz-fossrit.rhcloud.com/welcome.html>`_ teamed up
with the `Boston Museum of Science <http://www.mos.org/>`_ to make
"[An] educational game about the physics of light.  In it's current incarnation
it helps demonstrate the concepts of reflection and color filtering.  The
development team has plans to include other concepts such as refraction
and prisms in future releases."

.. image:: http://lazorz-fossrit.rhcloud.com/image/lazorzscreenshot.png
   :target: http://lazorz-fossrit.rhcloud.com/welcome.html

They got a nasty front-end built, by hand, with javascript and HTML5 that
**works on every mobile device we could test it on**.  It is intuitive and fun.
They have almost-working Facebook auth and they have an almost-working
Turbogears2 backed JSON store. (really, *this* close to completion!)

----

**#2** - `Gold Rush <http://gold-rush.rhcloud.com>`_ is visually and game-ly
amazing.  If I had to pick which of the three project was going to make one
million dollars, it'd be this one.

.. image:: http://i.imgur.com/XJCshh.jpg
   :target: http://gold-rush.rhcloud.com

The front-end is built in Unity (closed source, but compiles to a ton of
platforms) and the back-end JSON store is built in TurboGears2.  These guys
completely flew through development, mastering skills they'd never heard of in a
day.  Its 3D with a moving camera and an incredibly fun game.  The original game
idea belongs to team member `Eric Heaney
<http://ericheaney.wordpress.com/>`_.  It's fun to play as a normal old
card game (I've played it at a number of parties since he pitched it to
the class).

----

**#3** -- `WebBotWar <http://webbot-qalthos.rhcloud.com>`_ (the python web
robot fighting game) wins the prize for `master hack
<http://github.com/CodingRobots>`_.  They:

 - Forked `pybotwar <http://code.google.com/p/pybotwar/>`_, ripped it's UI off
   and made it export JSON.
 - Reimplemented the front-end with `jCanvas
   <http://calebevans.me/projects/jcanvas/index.php>`_ (and cooked up all
   their own art assets!).
 - Wrote a TurboGears2 app that spins up serverside instances of their
   pybotwar fork.

   - Those instances dump their state into mongodb (or memcached, long story).
   - Their javascript client polls the TG2 app for the game state and `voilà
     <http://webbot-qalthos.rhcloud.com>`_.

They have (awesome) plans to:

 - Allow you to upload your own scripts (they have it working, just not secured).
 - Make a built-in script editor.
 - Tighter facebook integration (challenge your friends!)

BTW, it works on android and iPad.  It even works on `Epiphany
<http://projects.gnome.org/epiphany/>`_ (`wat?
<https://www.destroyallsoftware.com/talks/wat>`_)  They also want you
to know that python `box2d <http://code.google.com/p/pybox2d/>`_ is
a pain in the ass.

.. image:: https://github.com/ralphbean/WebBot/raw/c127a15b0c5f1d5683c7619676fc7aec4970e061/pywebbot-screenshot.png
   :target: http://webbot-qalthos.rhcloud.com/

