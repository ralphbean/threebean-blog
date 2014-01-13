---
categories: fedora,fedora-packages,bugz
date: 2014/01/13 16:10:00
permalink: http://threebean.org/blog/bugz-switchover
title: bugz.fp.o EOL and switchover
---

During the F20 release cycle and holidays, the infrastructure team tries not to
make any disruptive changes to our web services.  Now its January, we have a
spate of built-up changes lined up for deployment.  Lots of changes have been
pushed out already.

One major change still to come is the introduction of pkgdb2 and the
retirement of pkgdb.  The original pkgdb provided an interface to Red Hat
bugzilla made friendlier by an alias at `bugz.fedoraproject.org
<https://bugz.fedoraproject.org>`_.  For instance, visiting
`bugz.fedoraproject.org/nethack <https://bugz.fedoraproject.org/nethack>`_
would take you to `admin.fedoraproject.org/pkgdb/acls/bugs/nethack
<https://admin.fedoraproject.org/pkgdb/acls/bugs/nethack>`_.

Once pkgdb1 is retired, that will no longer be the case;
`bugz.fedoraproject.org/nethack <https://bugz.fedoraproject.org/nethack>`_ will
instead take you to the replacement interface on the fedora-packages webapp:
`apps.fedoraproject.org/packages/nethack/bugs/all
<https://apps.fedoraproject.org/packages/nethack/bugs/all>`_.


