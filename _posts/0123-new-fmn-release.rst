---
categories: fedora, fmn, fedmsg
date: 2015/01/16 13:05:00
permalink: http://threebean.org/blog/latest-fmn-release
title: New FMN Release -- Improved Default Preferences
---

It's been a while coming but this past week I released and deployed a new cut
of `FMN, Fedora's Fedmsg Notification system
<https://apps.fedoraproject.org/notifications>`_ (it's a neat webapp that can
send you notifications of events as they happen throughout Fedora
Infrastructure).  The release is full of bug fixes and little feature
enhancements, I'll talk about a few here:

- **New defaults** - this is the big one.  The default settings were the
  biggest issue raised by early adopters.  The complaints fell along two main
  axes:  1) the defaults deliver lots of messages that most users won't want
  and 2) the defaults are hard to understand and therefore hard to modify.

  - In that first respect, the settings have been narrowed down greatly such
    that now you don't receive notifications about the bulk of your own
    activity. One of the most absurd cases was IRC meetings.  If you were
    participating in an IRC meeting, you would get emails about *topic changes*
    in the IRC meeting you were already participating in.  Clearly, you don't
    need an email about that.

  - With the revised defaults, there are two main filters built:  **"Events on
    packages I own, except this kind, this kind, and that kind"** and **"Events
    involving my username, except this kind, this kind, and that kind."**
    These are hopefully more intuitive to read and modify.  Initial feedback
    from testers has been positive.

  - There's also a new ``@mention`` filter that comes with the defaults which
    will notify you if someone references ``@your_fas_username`` anywhere in a
    fedmsg message, i.e. if someone adds ``@ralph`` in a fedorahosted trac
    ticket, I'll get a ping by IRC about it.

  There's a button in the web interface you have to press to discard your
  current preferences and load in the new defaults.  Try it out!  Here's where
  you find it:

  .. image:: http://threebean.org/img/fmn-reset.png
     :width: 600px
     :target: http://threebean.org/img/fmn-reset.png
     :alt: Where to find the reset button in the FMN web interface

- *On to other new features*, there is now a sensible **digest mode for IRC**
  that will collapse some collections of messages into one.  It looks
  something like this:

  - mschwendt and hobbes1069 commented on freecad-0.14-5.fc20,smesh-6.5.3.1-1.fc20
  - limb changed sagitter's commit, watchcommits, and 2 others permissions on engauge-digitizer (epel7) to Approved
  - kevin requested 2 xfdesktop stable updates for F21 and F20
  - limb changed group::kde-sig's commit, watchcommits, and watchbugzilla permissions on ksysguard (f21, f20, and master) to Approved
  - sagitter submitted 4 engauge-digitizer testing updates for F21, F20, and 2 others
  - remi submitted 4 php-phpseclib-file-asn1 testing updates for F21, F20, and 2 others

  Currently it can only collapse `bodhi
  <https://admin.fedoraproject.org/updates>`_ and `pkgdb2
  <https://admin.fedoraproject.org/pkgdb>`_ messages, but there will be more
  cases handled in the future (plus we can re-use this code for the new `Fedora
  Hubs
  <http://blog.linuxgrrl.com/2014/04/16/design-hub-idea-fedora-next-website-redesign/>`_
  thing we're cooking up).

- There is now a **long form format** for some messages over email.
  Specifically, git pushes to `dist-git <http://pkgs.fedoraproject.org>`_ will
  include the patch in the email.  If you have requests for other kinds of
  information you want forwarded to you, please `file an RFE
  <https://github.com/fedora-infra/fmn/issues/new>`_ so we know what to prioritize.

Lastly, I'll say that making the most of FMN requires a little bit of
imagination (which can be hard to do if you aren't already familiar with it).
Here are some for custom filters you could build for your account:

- I get IRC notifications about all my github events now through FMN.  I built
  a filter to forward messages that:

  - **are** a github message
  - **match** the regex ``(ralphbean|fedora-infra)`` (which simply means the
    message must contain either ``ralphbean`` or ``fedora-infra``)
  - **are not** continuous integration updates from Travis-CI.org (because those are spammy)
  - **are not** deletions of tags or branches, since I don't care too much about those

  And I use that to follow Fedora Infrastructure app development -- new pull
  requests, new issues, etc..

  .. image:: http://threebean.org/img/github-stuff.png
     :width: 600px
     :target: http://threebean.org/img/github-stuff.png
     :alt: Where to find the reset button in the FMN web interface

- You could apply a similar scheme and build a filter to follow something in
  Fedora you're an expert at or want to learn more on.  You could for instance
  build a filter for ``"systemd"`` like this:

  - **include** messages that match the regex ``systemd``
  - **ignore** All messages from the Koji build system
  - **ignore** All messages from dist-git SCM.

  And you would be left with notifications from `Ask Fedora
  <https://ask.fedoraproject.org>`_ anytime anyone asks a question about
  systemd and `the wiki <https://fedoraproject.org/wiki>`_ anytime some
  documentation gets updated that mentions systemd.

Anyways, please give the latest FMN a test and `report any issues
<https://github.com/fedora-infra/fmn/issues>`_ as you find them.  Cheers!
