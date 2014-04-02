---
categories: fedora,fedmsg,pkgdb
date: 2014/04/02 15:40:00
permalink: http://threebean.org/blog/pkgdb-acls-speedup
title: PkgDB ACL changes should be much quicker now
---

So, it **used** to be that when someone was granted *commit* access to a
package in the `Fedora PackageDB (pkgdb) <https://admin.fedoraproject.org>`_,
the webapp simply wrote to a database table indicating the new relationship.
Every *hour*, a cronjob would run that queried the state of that database and
then re-wrote out the ACLs for gitolite -- the software that manages access to
our `package repositories <http://pkgs.fedoraproject.org>`_.

Consequently, we had lots of *waiting*: you would request commit access to a
repository, then *wait* for an owner to grant you rights, then *wait* for that
cronjob to run before you could actually push.

With `this new fedmsg consumer
<https://github.com/fedora-infra/fedmsg-genacls/blob/develop/fedmsg_genacls.py>`_
that we have in place, those gitolite ACLs will be re-written in response to
fedmsg messages from the pkgdb.  It is much faster, although not instantaneous.
Ballpark: 2 minutes.

Happy hacking!
