---
categories: fedora, fedmsg, notifications
date: 2014/09/16 20:32:00
permalink: http://threebean.org/blog/new-fmn-release
title: Fedora Notifications, 0.3.0 Release
---

Just as a heads up, a new release of the `Fedora Notifications app (FMN)
<https://apps.fedoraproject.org/notifications>`_ was deployed today (version
``0.3.0``).

Frontend Improvements
---------------------

**Negated Rules** -  Individual rules (associated with a filter) can now be
negated.  This means that you can now write a rule like:  "forward me all
messages mentioning my username **except for** meetbot messages and those
*secondary arch* koji builds."

**Disabled Filters** - Filters can now be *disabled* instead of just *deleted*,
thus letting you experiment with removing them before committing to giving them
the boot.

**Limited Info** - The information on the "context" page is now successively
revealed.  Previously, when you first visited it, you were presented with an
overwhelming amount of information and options.  It was not at all obvious that
you had to 'enable' a context first before you could receive messages.  It was
furthermore not obvious that even if you had it enabled, you still had to enter
an irc nick or an email address in order for things to actually work.  It now
reveals each section as you complete the preceding ones, hopefully making
things more intuitive -- it warns you that you need to be signed on to freenode
and identified for the confirmation process to play out.

**Truncated Names** - Lastly and least, on the "context" page, rule names are
no longer truncated with a ``...``, so you can more easily see the entirety of
what each filter does.

Backend Improvements
--------------------

**Group Maintainership** - There's a new feature in pkgdb as of this summer:
*groups can now be maintainers of packages*.  I.e. the ``perl-sig`` group can
own a number of core perl packages.  FMN didn't know to route messages about
such packages to you if you're a member of the ``perl-sig`` group, but now it
does.

**Automatic Accounts** - And lastly, with an eye to the future, when *new FAS
accounts are added to the packager group*, FMN notices this and creates them an
FMN account turned on by default.  (This is in preparation for the `upcoming
switch of FMN from opt-in to opt-out for packagers
<https://lists.fedoraproject.org/pipermail/devel-announce/2014-September/001434.html>`_.)

**Clock Skew** - There's a feature where the IRC backend will try to tell you how
delayed it was in delivering your message.  If your koji build finishes while
FMN is busy with other stuff, when it finally gets to your message it will tell
you "your koji build finished 2 minutes ago".  There was a little cosmetic bug
in this where, due to clock skew between servers, FMN would tell you that "your
koji build finished 2 seconds in the future".. confusing!  This release fixes
that.

**Cache Locking** - The backend keeps an in-memory cache of everyone's
notification preferences (which it intelligently invalidates based on fedmsg
activity).  Some optimization improvements were made on the thread locking
around that cache.

----

Thanks for all the `RFEs and bugs filed so far
<https://github.com/fedora-infra/fmn/issues>`_.  Happy Hacking!
