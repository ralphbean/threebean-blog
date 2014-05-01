---
categories: fedora, pycon
date: 2014/05/01 11:50:00
permalink: http://threebean.org/blog/thoughts-on-pycon-2014
title: Thoughts on PyCon 2014
---

So I got to attend `PyCon US <http://us.pycon.org>`_ again this year and while
its customary to write a little report when you return from such a thing, I
feel like, now a month past, that I've lollygagged so long that the writer's
block is getting worse, not better.  Now my report is untimely and it feels odd
to even publish it.  Better late than never?  Yes.  Let's go with that!

Framing
-------

`Jessica McKellar's keynote was amazing
<http://pyvideo.org/video/2684/keynote-jessica-mckellar>`_.  It was good in its
own right, but was also important in so far as it framed the process of change
ongoing in both the python community and its major conference.  People know
the `state of women in FLOSS is abysmal
<http://geekfeminism.wikia.com/wiki/FLOSS>`_.  The effort to turn things around
was clear and front and center this year: `"outreach works"
<https://twitter.com/jessicamckellar/statuses/413009020522221568>`_.

`Guid Van Rossum's keynote
<http://pyvideo.org/video/2686/keynote-guido-van-rossum-0>`_ featured a "no to
2.8" image meaning, there is not nor will there be a python-2.8 release.  For
Fedora and its downstreams, it serves as a reminder that we need to beef up on
python3 preparedness.  We're `making progress
<https://fedoraproject.org/wiki/Python3>`_.  Do pay attention to the proposed
change to make `python 3 the default in Fedora 22
<https://fedoraproject.org/wiki/Changes/Python_3_as_Default>`_ and help clear
the way where you can.

Diversion into ML
-----------------

I attended a number of `talks <http://pyvideo.org/category/50/pycon-us-2014>`_
on machine learning and big data and got all inspired.  I wrote `this little
throwaway program <https://gist.github.com/ralphbean/4c2d4105ea2c7e407fb5>`_ in
between sessions.  It reads in a bunch of newgroups and then tries to predict
which newsgroup each posting belongs to (and after lots of tweaking, it got a
100% success rate which is crazy).

Ultimately, what I want to do is write a plugin for mailman3.  In the
`mailman3/hyperkitty UI
<http://lists.stg.fedoraproject.org/archives/list/devel%40lists.fedoraproject.org/2013/12/>`_
you can tag/categorize threads.  Each community I imagine would end up tagging
threads with their own jargon:  "this thread is a flamewar", "this is a feature
request", "this one's a bug report", "this is a moonshot".. or whatever.  We
could build a plugin that reads in all those tags for each community and then
builds a predictive model that can be applied to new messages as they come in.

We could proactively tag messages using the community's own jargon!  My `little
script <https://gist.github.com/ralphbean/4c2d4105ea2c7e407fb5>`_ seems to work
well enough and we `know how to build mailman3 plugins
<http://threebean.org/blog/plugins-for-mailman3/>`_.  At this point we just
have to wait for the community to accumulate a set of real world tags we could
train and test against.

*Anyways*...

Sprints
-------

Just being there puts us in a position to build relationships with
other upstreams and the rest of the community but the PyCon sprints were
concretely productive for us this year.  A couple people from `my team
<https://fedoraproject.org/wiki/Fedora_Engineering>`_ were present.

- Aurélien got his changes merged into mailman proper(!) and they
  prepared to cut a beta release of the whole suite(!!).
- Toshio put work in on warehouse, the next generation of PyPI.
- Luke tore it up on Bodhi2 (*crystal ball -- we'll have it deployed before
  Flock this year*).
- I got a barrel's worth of python3 porting done (fedmsg is now python3
  ready!).

Shout out
---------

My good friend Remy Decausemaker got the spot to give the `very very last
lightning talk at pycon <http://youtu.be/NSLvERZQSok?t=1h17m43s>`_ entitled
"Adventures in Hackademia" where he talked about the `the first open source
collegiate minor in the US
<https://community.redhat.com/blog/2014/03/how-the-first-minor-in-foss-grew-from-an-idea-into-foss-magic/>`_
that some of us have been helping to get started.  Very exciting.
