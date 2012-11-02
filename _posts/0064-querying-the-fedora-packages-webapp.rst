---
categories: gnome, python, fedora
date: 2012/11/02 16:30:00
permalink: http://threebean.org/blog/querying-the-fedora-packages-webapp
title: Querying the Fedora Packages webapp
---

This post is about the python client stack I've been building
around the `Fedora Packages webapp <https://apps.fedoraproject.org>`_.

That webapp is a replacement for the `old fedora-community
<https://admin.fedoraproject.org/community/>`_.  It indexes a ton of
information from Fedora Infrastructure and presents it in a
package-centric way.  It was developed by `J5 <http://www.j5live.com/>`_,
`Luke Macken <http://lewk.org>`_, and `Máirín Duffy
<http://blog.linuxgrrl.com/>`_.

From the Gnome Shell
--------------------

The latest addition is a gnome-shell-3.6-compatible search provider that
includes hits from the Packages webapp in your gnome-shell search results.
No `Amazon sponsored results
<https://www.eff.org/deeplinks/2012/10/privacy-ubuntu-1210-amazon-ads-and-data-leaks>`_
-- I promise.

It's called `gnome-shell-search-fedora-packages
<https://apps.fedoraproject.org/packages/gnome-shell-search-fedora-packages>`_
and I made `this screencast <https://vimeo.com/52710022>`_ showing it in action.

Writing it has got me excited to make search providers for all kinds of
things:  github repositories, pinterest results, etc..  This `SSH search
provider <https://extensions.gnome.org/extension/73/ssh-search-provider/>`_
is a great idea (althought it doesn't seem to work right now).  "Search
your ``~/.ssh/config`` for named remote locations and pop open terminals to
them on activation."

From the Command Line
---------------------

You can also search the `Fedora Packages app
<https://apps.fedoraproject.org/packages>`_ from the console with my `pkgwat
<http://apps.fedoraproject.org/packages/pkgwat>`_ tool::

    --- ~ » pkgwat search nethack
    +------------------+-----------------------------------------------------+
    | name             | summary                                             |
    +------------------+-----------------------------------------------------+
    | nethack          | A rogue-like single player dungeon exploration game |
    | nethack-vultures | NetHack - Vulture's Eye and Vulture's Claw          |
    | slashem          | Super Lotsa Added Stuff Hack - Extended Magic       |
    | crossfire        | Server for hosting crossfire games                  |
    | crossfire-client | Client for connecting to crossfire servers          |
    +------------------+-----------------------------------------------------+

But you can also extract more specific information, like a summary::

    --- ~ » pkgwat info nethack
    +--------------+------------------------------------------------------------------------+
    | Field        | Value                                                                  |
    +--------------+------------------------------------------------------------------------+
    | upstream_url | http://nethack.org                                                     |
    | description  | NetHack is a single player dungeon exploration game that runs on a     |
    |              | wide variety of computer systems, with a variety of graphical and text |
    |              | interfaces all using the same game engine.                             |
    |              |                                                                        |
    |              | Unlike many other Dungeons & Dragons-inspired games, the emphasis in   |
    |              | NetHack is on discovering the detail of the dungeon and not simply     |
    |              | killing everything in sight - in fact, killing everything in sight is  |
    |              | a good way to die quickly.                                             |
    |              |                                                                        |
    |              | Each game presents a different landscape - the random number generator |
    |              | provides an essentially unlimited number of variations of the dungeon  |
    |              | and its denizens to be discovered by the player in one of a number of  |
    |              | characters: you can pick your race, your role, and your gender.        |
    | name         | nethack                                                                |
    | summary      | A rogue-like single player dungeon exploration game                    |
    | link         | https://apps.fedoraproject.org/packages/nethack                        |
    | devel_owner  | lmacken                                                                |
    +--------------+------------------------------------------------------------------------+

Bodhi metadata::

    --- ~ » pkgwat releases nethack
    +---------------+----------------+-----------------+
    | release       | stable_version | testing_version |
    +---------------+----------------+-----------------+
    | Rawhide       | 3.4.3-27.fc18  | Not Applicable  |
    | Fedora 18     | 3.4.3-27.fc18  | None            |
    | Fedora 17     | 3.4.3-26.fc17  | None            |
    | Fedora 16     | 3.4.3-25.fc15  | None            |
    | Fedora EPEL 6 | None           | None            |
    | Fedora EPEL 5 | 3.4.3-12.el5.1 | None            |
    +---------------+----------------+-----------------+

And everything else the Packages app provides::

    --- ~ » pkgwat --help
    usage: pkgwat [--version] [-v] [-q] [-h] [--debug]

    CLI tool for querying the fedora packages webapp

    optional arguments:
      --version      show program's version number and exit
      -v, --verbose  Increase verbosity of output. Can be repeated.
      -q, --quiet    suppress output except warnings and errors
      -h, --help     show this help message and exit
      --debug        show tracebacks on errors

    Commands:
      bugs           List bugs for a package
      builds         List koji builds for a package
      changelog      Show the changelog for a package
      contents       Show contents of a package
      help           print detailed help for another command
      icon           Show the icon for a package
      info           Show details about a package
      releases       List active releases for a package
      search         Show a list of packages that match a pattern.
      updates        List bodhi updates for a package


From Python
-----------

Both `pkgwat <http://apps.fedoraproject.org/packages/pkgwat>`_ and the
`gnome shell search provider
<http://apps.fedoraproject.org/packages/gnome-shell-search-fedora-packages>`_
use a common Python API to get their information.  It's available on PyPI
as `pkgwat.api <http://pypi.python.org/pypi/pkgwat.api>`_ and from Fedora
as `python-pkgwat-api <http://apps.fedoraproject.org/packages/python-pkgwat-api>`_.

You can find the `full documentation on readthedocs.org <http://pkgwat.rtfd.org>`_::

    #!python
    import pprint
    import pkgwat.api

    pprint.pprint(pkgwat.api.releases("awesome"))
    {u'rows': [{u'release': u'Rawhide',
                u'stable_version': u'3.4.13-1.fc18',
                u'testing_version': u'Not Applicable'},
               {u'release': u'Fedora 18',
                u'stable_version': u'3.4.13-1.fc18',
                u'testing_version': u'None'},
               {u'release': u'Fedora 17',
                u'stable_version': u'None',
                u'testing_version': u'None'},
               {u'release': u'Fedora 16',
                u'stable_version': u'None',
                u'testing_version': u'None'},
               {u'release': u'Fedora EPEL 6',
                u'stable_version': u'None',
                u'testing_version': u'None'},
               {u'release': u'Fedora EPEL 5',
                u'stable_version': u'None',
                u'testing_version': u'None'}],
     u'rows_per_page': 10,
     u'start_row': 0,
     u'total_rows': 6,
     u'visible_rows': 6}


----

*And Ruby?* - Awesomely, David Davis just started work on a
`Ruby implementation <https://github.com/daviddavis/pkgwat>`_.
