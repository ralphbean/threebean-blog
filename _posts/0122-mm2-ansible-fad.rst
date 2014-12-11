---
categories: fedora, mirrormanager, ansible, fad
date: 2014/12/11 16:00:00
permalink: http://threebean.org/blog/mm2-ansible-fad
title: Infrastructure FAD Report -- MirrorManager2/Ansible
---

Last week we held a `FAD to work on mirrormanager2 and ansible
<https://fedoraproject.org/wiki/FAD_MirrorManager2_ansible-migration_2014>`_
(where `mirrormanager2 <https://github.com/fedora-infra/mirrormanager2>`_ is
the rewrite of `mirrormanager1 <http://fedorahosted.org/mirrormanager>`_ and
where by ansible we mean `the Fedora Infrastructure team's ansible setup
<http://infrastructure.fedoraproject.org/cgit/ansible.git>`_).

Mirrormanager2
--------------

`pingou wrote about it already
<http://blog.pingoured.fr/index.php?post/2014/12/06/Infra-FAD-2014-Part-1%3A-MirrorManager>`_
but the mirrormanager2 portion of the hackfest went well.  We had `mdomsch
<http://fedoraproject.org/wiki/User:Mdomsch>`_ with us (the original author of
mirrormanager1) and we spent almost the entire first day just picking his brain
-- asking questions to try and learn all the *why's* and *how's* of mirrormanager1.
pingou had done a lot of work before hand getting the web frontend rewritten in Flask,
the mirrorlist server needed some changes, but not an overhaul (lmacken ported
it away from paste to webob and wrote a much needed test suite).  Lots of time
was spent on the gaggle of cron jobs and update scripts that perform various
maintenance tasks on the database.

Two of the big ones are a local crawler (called "umdl") and a remote crawler
(called "crawler").  UMDL stands for "update master directory list": it crawls
the tree that Release Engineering has published to figure out what **should**
be mirrored.  Mirrors take care of rsyncing that content themselves, but with
this "should" list handy, the remote crawler can then later check which mirrors
**do** and **do not** have the latest content.  With that who-has-what list,
the ``mirrorlist`` server can then produce dynamically updated lists of where
you should and shouldn't get your *yum updates* from.

I spent most of my time on those two.  In common: I updated them to produce
fedmsg messages when they start and complete their work and to work against the
new database model.  I added some code to UMDL to identify and remember ostree
repos `for Fedora Atomic
<https://fedoraproject.org/wiki/Changes/Atomic_Cloud_Image>`_ and the remote
crawler got a refactoring too (moving from two scripts with a process manager
into one script with a thread pool), thus removing a couple hundred lines of
code, leveraging the Python standard library.

It's on its way to staging now and will get to simmer there for a while before
we roll it out.

Ansible
-------

nirik wrote about it `[1]
<http://www.scrye.com/wordpress/nirik/2014/12/09/mirrormanager-and-ansible-fad-day-5/>`_ `[2]
<http://www.scrye.com/wordpress/nirik/2014/12/08/mirrormanager-and-ansible-fad-day-4/>`_ `[3]
<http://www.scrye.com/wordpress/nirik/2014/12/07/mirrormanager-and-ansible-fad-day-3/>`_...
we did a wild amount of work on our ansible setup.  287 commits::

    ❯ git log --after 2014-12-03 --before 2014-12-09 --oneline | wc -l
    287

There was enough going on among the group that I don't have a good handle on
what all got done -- it was a lot! I worked on two things primarily:

With oddshocks, we got the `fedimg <https://github.com/fedora-infra/fedimg>`_
AWS image uploader working in staging and pushed out to production.

For the last two days of the FAD, I got almost all of the sprawling metropolis
that is our proxy layer ported over from puppet to ansible.  It's something
that wasn't fun, and doesn't really give us any new features to speak of.. but
it's something that's been bugging me for over a year now.  Everytime we add a
new app or migrate one from puppet to ansible, we have to **leave** some proxy
configuration for it over in the puppet repo, contributing to a *split-brain*
scenario between our config management systems.

Porting over the proxy layer involves touching *everything*.  Every app has an
entry there, every request has to go through it (and haproxy and varnish
(sometimes)).  It's something that could only get done in the company of the
rest of the team, with sustained effort, and with nothing else demanding our
attention; a perfect candidate for the FAD.  There's a few loose ends to tie
it up, but I'm glad to call it "almost done".

Two mistakes
------------

In general, FADs seem to be really effective for the infrastructure team.  We
got boatloads done at the bodhi2 FAD back in June -- same for this one.  If
there was a drawback this time, it's that we didn't have any explicitly planned
social events.  We went out for beers each night, but a lot of time we ended up
just talking more about what we were working on that day and next.  Day after
day for a weeklong sprint, that left us pretty crispy by the end.  We'd say
"oh, let's take a break and get lunch around this or that time" and hours would
pass only to find ourselves still working at 6 or 7pm.  Having scheduled breaks
*with something to do other than sit around and talk about what we're hacking
on* would help deflect burnout.  On the last night, lmacken and I went out to
play a poker game before catching planes back home in the morning.  It would be
cool to get the whole participation of the FAD in something next time.

The scheduling of this one ended up unlucky.  We were half hacking on
mirrormanager (unimpeded) and half hacking on our ansible setup -- *while on
the last week of the final release freeze for Fedora 21*.  The day we flew home
was release day!  We were all exhausted just in time for the shenanigans that
nirik has written about `here
<http://www.scrye.com/wordpress/nirik/2014/12/10/fedora-infrastructure-release-day-retrospective/>`_.

All in all: FAD -> good, a success.  I need to grab a nap and then finish off that
proxy layer port.. ;)  Happy hacking.
