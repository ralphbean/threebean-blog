---
categories: fedora, libravatar
date: 2013/07/16 10:20:00
permalink: http://threebean.org/blog/libravatar-psa
title: Public Service Announcement -- Use Libravatar!
---


tl;dr
-----

- I want you to sign up for libravatar (`click here
  <https://www.libravatar.org/account/new/>`_).
- Associate your ``FAS_USERNAME@fedoraproject.org`` email with it.
- Upload a photo.. any photo.
- Give yourself a high-five.

The Longer Story
----------------

There's contention out there about the "unix philosophy"... but whichever side
of the narrative you're on, the ability to *compose* our tools is a win!
This is long-settled on the desktop and server; there are more tools than you
can count.  On the web, it's another story.

There are some things that almost every web application needs to do for which
single-purpose web services have emerged (the analogue of single-purpose
composable command line tools).  Some examples:

- *Authentication*: openid
- *Authorization*: oauth2
- *Comment threads*: disqus
- *User images*: gravatar

If you're building a blog and you want comment threads, you just include a
snippet of javascript and *boom*, disqus provides the functionality, hosts your
data, and makes it available across blogs.  Super useful for the developer
and the user.  Super easy for the developer and the user.

If you're building a social app and you want user profile images, you just
include a one-liner and *boom*, gravatar provides the functionality, hosts your
data, and makes it available across sites.  Super useful for the developer
and the user.  Super easy for the developer and the user.

The big problem here is these services are proprietary software.

----

`libravatar <http://libravatar.com>`_ is the first free-as-in-libre entrant to
the field that I know of.  It works *just* like gravatar.  It also supports
federation via DNS.  It is copyleft licensed under the AGPL.

About a year ago, we started to use gravatar.com for Fedora Infrastructure
services.  We wrote some utilities into python-fedora that would make use of
it.  This was a mistake and we have since replaced them to use libravatar.

*However*, there is only a tiny sliver of the Fedora Community that actually
has their ``FAS_USERNAME@fedoraproject.org`` addresses associated with
libravatar accounts.  With more in place, it will flesh out and beautify the
apps we currently have in development.

So, again:

- Sign up for libravatar (`click here
  <https://www.libravatar.org/account/new/>`_).
- Associate your ``FAS_USERNAME@fedoraproject.org`` email with it.
- Upload a photo.. any photo.
- Give yourself a high-five.

If you want to discuss further or have concerns or questions, feel free to
chime in here on my proprietary soul-deflating comment service, or join us
in ``#fedora-apps`` on freenode.
