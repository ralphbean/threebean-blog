---
categories: fedora, zodbot
date: 2014/09/29 09:52:00
permalink: http://threebean.org/blog/two-new-zodbot-commands
title: Two New zodbot Commands
---

Our friendly neighborhood irc bot ``zodbot`` gained some `new powers
<https://fedoraproject.org/w/index.php?title=Zodbot&diff=389014&oldid=375880>`_
last week:

First, **.vacation** will tell you who is on vacation right now according to
the `fedocal vacation calendar
<https://apps.fedoraproject.org/calendar/vacation/>`_::

    │ threebean │ .vacation
    │    zodbot │ threebean: The following people are on vacation:
    │           │ cicku, monnerat, tomspur, vondruch, nphilipp, kdudka, mtasaka

Second, **.pulls** will report back the list of *open pull requests* on a given
GitHub repository.  Hopefully this will catch on among Fedora Infrastructure
app developers as a way to facilitate and prompt code review::

    │ threebean │ .pulls fedora-infra/tahrir
    │    zodbot │ threebean: @oddshocks's "Add checks to check for attempted
    │           │ duplicate additions of things in admin panel."
    │           │ https://github.com/fedora-infra/tahrir/pull/286
    │    zodbot │ threebean: @hroncok's "Reenable gravatar fallback"
    │           │ https://github.com/fedora-infra/tahrir/pull/209

Writing ``zodbot`` plugins is fun and you can do it too.  The source can be
found in git `right here <https://github.com/fedora-infra/supybot-fedora>`_.
