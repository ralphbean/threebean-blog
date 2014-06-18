---
categories: fedora, github, fedmsg
date: 2014/06/18 14:15:00
permalink: http://threebean.org/blog/github2fedmsg
title: github + fedmsg, sign up your repos to feed the bus
---

I'm proud to announce `a new web service
<https://apps.fedoraproject.org/github2fedmsg>`_ that bridges upstream GitHub
repository activity into the `fedmsg bus <http://fedmsg.com>`_.

.. image:: https://apps.stg.fedoraproject.org/github2fedmsg/static/github2fedmsg.png
   :target: https://apps.fedoraproject.org/github2fedmsg
   :width: 80%

Please check it out and `let us know
<https://github.com/fedora-infra/github2fedmsg/issues>`_ of any bugs you find.
The regular fedmsg topics documentation shows examples of just `what kinds of
messages get rebroadcasted
<http://fedora-fedmsg.readthedocs.org/en/latest/topics.html>`_, so you can read
all about that there if you like.  The site has a neat dashboard that let's you
toggle all of your various repos on and off -- you have control over which of
your projects get published and which don't.

I know there's concern out there about building any kind of dependency between
our infrastructure and proprietary stacks like GitHub, Inc.  This new GitHub
integration was a quick-win because we could do it 1) securely, (`unlike with
transifex
<http://support.transifex.com/customer/en/portal/questions/6100078-webhook-signature->`_),
2) with a low-maintenance, self-service dashboard, and 3) lots of our upstreams
are on github or have mirrors on github.  If you have another message source
out there that you'd like to bridge in, drop into ``#fedora-apps`` and let me
know.  We'll see if we can figure something out that will work.

Anyways.. we should probably make some `Fedora Badges
<https://badges.fedoraproject.org>`_ for `upstream development activity
<https://fedorahosted.org/fedora-badges/ticket/40>`_ now, right?  And, as a
heads up, be on the lookout for new `jenkins
<https://github.com/fedora-infra/jenkins-fedmsg-emit>`_ and `bugzilla
<https://github.com/fedora-infra/bugzilla2fedmsg>`_ integration... coming soon.

Happy Hacking!
