---
categories: gnome, dbus, python, fedora
date: 2012/10/31 12:30:00
permalink: http://threebean.org/blog/query-gs-search-providers-over-dbus-with-python
title: Querying Gnome-Shell Search Providers Over DBUS with Python
---

I'm working on a gnome-shell search provider to query the `Fedora Packages
<http://apps.fedoraproject.org/packages>`_ webapp with the `pkgwat python api
<http://pkgwat.rtfd.org>`_.

In older versions of the gnome-shell, this used
to be super simple -- you would just drop an `XML file
<http://threebean.org/usr/share/gnome-shell/open-search-providers/pinboard.xml>`_
in ``/usr/share/gnome-shell/open-search-providers`` that defined a URL for
where to search for stuff.

GNOME changed the way this all worked in
gnome-shell 3.6 and you have to have an actual dbus service that returns
results now.  I haven't figured that part all out yet but I'm on the way.

Part of the first step was figuring out how the existing search providers
worked, so I wrote this little python snippet to query the Documents search
provider.  Maybe you'll find it useful::

    #!python
    import dbus
    import pprint

    bus = dbus.SessionBus()
    proxy = bus.get_object(
        # Query the Documents search provider...
        'org.gnome.Documents.SearchProvider',
        '/org/gnome/Documents/SearchProvider',

        # Or query my own search provider instead...
        #'org.fedoraproject.fedorapackages.search',
        #'/org/fedoraproject/fedorapackages/search',
    )

    # which interface do we make our calls against?
    kw = dict(dbus_interface="org.gnome.Shell.SearchProvider")

    # This is what we want to search our docs for
    term = "aw"  # = "foobartest"

    ids = proxy.GetInitialResultSet(term, **kw)

    result = proxy.GetResultMetas(ids, **kw)
    result = [dict(item) for item in result]

    pprint.pprint(result)

`J5's <http://www.j5live.com/>`_ tool `d-feet <https://live.gnome.org/DFeet/>`_
was indispensable in figuring this out.  This `dbus-python tutorial
<http://dbus.freedesktop.org/doc/dbus-python/doc/tutorial.html>`_ was super
useful too.

For my own search provider, I forked `lmacken's fedmsg-notify
<http://github.com/lmacken/fedmsg-notify>`_ as a starting point.  More on that
later.
