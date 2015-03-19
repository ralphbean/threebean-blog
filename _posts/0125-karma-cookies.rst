---
categories: fedora, badges, fedmsg
date: 2015/03/19 10:16:00
permalink: http://threebean.org/blog/karma-cookies
title: Karma Cookies, and how to give them
---

It took a while to get all the ingredients together, but we *baked* up a
*delicious batch* of new `Fedora Badges <https://badges.fedoraproject.org>`_ and
they're fresh out of the oven.

To quote `mizmo <http://blog.linuxgrrl.com/>`_ from the `original ticket
<https://fedorahosted.org/fedora-badges/ticket/328>`_::

    So here's the idea. The FPL has the FPL blessing, right? But, someone did
    something really helpful and awesome for me today, with no expectation of
    getting anything in return. This person really made my life easier. And I
    really wish I could give him something as a token of my appreciation.

    So my thought here - maybe everyone in the Fedora project gets an amount of
    cookie badges that they can hand out as thank yous to others in the project as
    they're getting things done and helping each other out. You can't award one to
    yourself, only others. Maybe you get one cookie for every 5 badges you have
    earned, so folks get a number of cookies proportional to their achievements in
    the system, and if they run out they can replenish their cookies by earning
    more badges.

The excellent `riecatnor <https://riecatnor.wordpress.com/>`_ got to work and whipped up some treats:

.. image:: https://badges.fedoraproject.org/pngs/macaroncookie.png
   :width: 400px
   :target: https://badges.fedoraproject.org/badge/macaron-cookie-i

The last missing piece was a `new plugin for zodbot
<https://github.com/fedora-infra/supybot-fedora/pull/22>`_ that listens for
``USERNAME++`` in IRC and publishes a `new karma message
<http://apps.fedoraproject.org/datagrepper/raw?category=irc>`_ to
Fedora Infrastructure's `message bus <http://fedmsg.com>`_.

That's all done and in place now.  You can grant someone karma like this::

  | threebean | riecatnor++

And check to see how much karma a given user has like this::

  | threebean │ .karma riecatnor
  |    zodbot │ threebean: Karma for riecatnor has been increased 1 times

Lastly, there are a handful of restrictions on it.  You can only give karma to
a particular individual once (although you have an unlimited supply of points
to give to the entire Fedora community)::

  | threebean │ riecatnor++
  |    zodbot │ threebean: You have already given 1 karma to riecatnor

You can't give yourself karma::

  | threebean │ threebean++
  |    zodbot │ threebean: You may not modify your own karma.

You can only give karma **to** fas users, and you can only give karma **if you
are** a fas user (your irc nick must match your fas username **or** you must
have your ircnick listed in `FAS <https://admin.fedoraproject.org/accounts>`_.

There's code in the plugin to allow negative karma, i.e. ``threebean--``, but
we have that disabled.  Best to stay positive!  ;)

Enjoy!  As always, if you have questions about this stuff, please do jump
into ``#fedora-apps`` on freenode and ask away!

.. image:: http://i.imgur.com/vK7Cl.gif
   :width: 400px
