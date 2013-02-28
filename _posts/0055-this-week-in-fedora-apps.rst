---
categories: fedora, fedmsg
date: 2012/08/23 16:30:00
permalink: http://threebean.org/blog/this-week-in-fedora-apps
title: This Week in Fedora Infrastructure Apps
---

Just got out of the `Fedora Infrastructure weekly meeting
<http://bit.ly/PAnt6F>`_.  Some highlights from the development side of things:

**Status app** -- http://status.fedoraproject.org/ is live.  Keep it open in a
tab in your browser; the favicon should dynamically change when `sysadmin-noc`
declares an outage.

**pkgdb migration** --
There's a `plan in the works <http://bit.ly/O99nFi>`_ to migrate *some pieces*
of pkgdb out to other apps where those pieces make more sense.  Some of those
pieces (in `/packages` and `/tagger` have hit staging).

`fedora-packages <https://apps.stg.fedoraproject.org/packages/dracut/bugs>`_
has a ``/bugs`` path that we intend to replace bugz.fedoraproject.org some
day.  How does it look?  Need more work?

`fedora-tagger <https://apps.stg.fedoraproject.org/tagger/>`_ can now export a
sqlite-db for yum like pkgdb's ``sqlitebuildtags`` did.  We still need to test
that it works with bodhi's masher before moving forwards with it.

**Raw stream** --
You can now access a raw stream of `zmq <http://www.zeromq.org/>`_ messages
from our staging infrastructure.

I'll have a handy works-out-of-the-box fedmsg config coming to your Fedora repo
soon but in the meantime, you could try connecting to it yourself by running
`this script <https://gist.github.com/3440830>`_ like ``$ python topics_sub.py
tcp://stg.fedoraproject.org:9940``.

You won't see much; its only broadcasting
the quiet solace of our staging environment.  But to make it and `busmon
<https://apps.stg.fedoraproject.org/busmon/>`_ dance, you could go hit `the
staging wiki <https://stg.fedoraproject.org/wiki>`_, login, and make an edit.

`rossdylan <http://blog.helixoide.com/>`_ is working on a desktop notification
app that will hook into this.  Awesome.

**Websockets** -- (`moksha <http://mokshaproject.net>`_, ftw)
This was the one of the first things I wrote when I started work
on fedmsg, and it finally made it to staging.

Check it out at https://apps.stg.fedoraproject.org/busmon/.  Think of it
as a web based version of ``#fedora-fedmsg`` with live regex
filtering.  You won't see much data.  It's just displaying messages
from the staging bus.

**New hooks** -- I have an untested `fedmsg koji plugin <http://bit.ly/OQrTr4>`_
ready to try out once `staging has a builder <http://bit.ly/QStvff>`_.

There's also a new supybot plugin (supybot-fedmsg) that is ready to try out, but there's
no stg instance of zodbot to do this easily.  I'll wait until post-freeze.  I
like the code a bunch.. it is kind of `magical <http://bit.ly/O8PTAW>`_.

You can always track the status of all the hooks at the `fedmsg status page
<http://fedmsg.readthedocs.org/en/latest/status.html>`_.
