---
categories: python, fedora
date: 2012/05/02 18:00:00
permalink: http://threebean.org/blog/upstream-checkery
title: Are my Fedora packages handled by Upstream Release Monitoring?
---

I just recently started packaging up a bunch of stuff for `Fedora 17
<http://beefymiracle.org/>`_ and have had to learn the ins-and-outs of
`package review <http://fedoraproject.org/wiki/Package_Review_Process>`_.
The final step in the `how-to-get-your-package-into-Fedora story
<http://fedoraproject.org/wiki/New_package_process_for_existing_contributors>`_
is to enable `upstream release monitoring
<http://fedoraproject.org/wiki/Upstream_Release_Monitoring>`_ for your package.

I'd forgotten to do this a few times.  Oop!  So I wrote the following little
script to ask `pkgdb <http://admin.fedoraproject.org/pkgdb>`_ for all my
packages, compare them against `the list of monitored packages
<http://fedoraproject.org/wiki/Upstream_Release_Monitoring>`__, and print the
result.  Maybe you'll find it useful::

    #!python
    #!/usr/bin/env python
    """
    List the Fedora packages I own by their status in Upstream Release Monitoring.

    Requires a few python modules::

        $ sudo yum install python-fedora

    """

    import fedora.client
    import os
    import urllib2

    URL = "http://fedoraproject.org/wiki/Upstream_release_monitoring"

    auth_system = 'Fedora Account System'

    symbols = {
        False: ' - ',
        True: ' + ',
    }

    if __name__ == '__main__':
        pkgdb = fedora.client.PackageDB()

        username = os.environ.get("BODHI_USER")
        print "* Packages for FAS user %r" % username

        pkgs = pkgdb.user_packages(username).pkgs

        page = urllib2.urlopen(URL).read()

        for pkg in pkgs:
            print symbols[pkg.name in page], pkg.name
