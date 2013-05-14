---
categories: fedora, fedmsg, fedorahosted
date: 2013/05/14 14:15:00
permalink: http://threebean.org/blog/fedorahosted-on-fedmsg
title: FedoraHosted gets on the bus
---

Last week I wrote a plugin to make `trac <https://trac.edgewall.com>`_ emit
`fedmsg <http://fedmsg.com>`_ messages.  We installed it first on a few
projects to make sure it worked ok, and everything seems fine.  If you're
watching the ``#fedora-fedmsg`` channel on freenode, you may have already
noticed some ``trac.ticket.update`` messages go by.

It is currently enabled for the following projects:

- `Comps <https://comps.fedorahosted.org>`_
- `FAMA <https://fedorahosted.org/fama>`_
- `FESCo <https://fedorahosted.org/fesco>`_
- `Fedora Infrastructure <https://fedora-infrastructure.fedorahosted.org>`_
- `Fedora Website <https://fedora-websites.fedorahosted.org>`_
- `Moksha <https://moksha.fedorahosted.org>`_
- `Release Engineering <https://rel-eng.fedorahosted.org>`_
- `Spin Kickstarts <https://spin-kickstarts.fedorahosted.org>`_

If you want it enabled for *YOUR* fedorahosted project, please `open an
infrastructure ticket
<https://fedorahosted.org/fedora-infrastructure/newticket>`_ and we'll get
to it as soon as we can.  It's really pretty easy to set up; someone on
the infrastructure team just needs to follow this documented `Standard
Operating Procedure
<http://infrastructure.fedoraproject.org/infra/docs/fedorahosted-fedmsg.txt>`_.
