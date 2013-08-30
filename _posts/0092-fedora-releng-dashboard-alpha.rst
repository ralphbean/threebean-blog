---
categories: fedora, releng, fedmsg, datagrepper
date: 2013/08/30 16:35:00
permalink: http://threebean.org/blog/a-release-engineering-dashboard
title: A Release Engineering Dashboard?
---

Messing around, I came up with a read-only dashboard for Fedora `Release
Engineering <https://fedoraproject.org/wiki/ReleaseEngineering>`_.  You can
check it out `live on threebean.org
<http://threebean.org/fedora-releng-dash/>`_.

.. image:: static/images/fedora-releng-dashboard-2013-08-30.png
   :alt: Screenshot of an alpha dashboard for Release Engineering.
   :target: http://threebean.org/fedora-releng-dash/

ight now all it does is try to show the status of the *compose* process which
runs once a day for rawhide and the "branched" pre-release (that's F20 right
now).  If any one of the components of that process (say, the pungify part) is
happening right now, it'll tell you that and have it show up in yellow in stead
of blue.  If the compose hasn't happened in over 20 hours, that text will show
up in gray to indicate that it is "stale" or "out of date" (those words might
be too strong, but whatever).

The *point* of this post is to ask for feedback -- should this thing do
anything more?  If so, then what?  Should we make it live under
fedoraproject.org?

(**details**: It's just HTML, CSS, and js and it makes its queries against
`datagrepper <https://apps.fedoraproject.org/datagrepper>`_)
