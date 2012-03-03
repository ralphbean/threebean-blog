---
categories: python, github, toscawidgets
date: 2012/03/03 11:00:00
permalink: http://threebean.org/blog/listing-github-repos
title: Listing all my tw2 github repositories
---

Just starting out on the `tw2 bugsprint
<http://threebean.org/blog/announcing-tw2-bugsprint>`_ this morning.
I'm working on `adding CompoundValidator support
<https://bitbucket.org/paj/tw2core/issue/74/add-compound-validators>`_ and `Greg
Jurman <https://github.com/gregjurman>`_ is working on `resolving the duplicate
JS encoders
<https://bitbucket.org/paj/tw2core/issue/92/duplicate-tw-encoders>`_.  That
later one is a real pain.  There are tons of widget libraries out that that use
one set of JS objects, and plenty that use the others.  To find out what uses
what (so we can refactor with less pain) I had to ping my github account to find
out the full list of tw2 libraries I've written.

Here it is!  Using ``github2`` to get a list of every repo (so I can clone and
``$ grep -nr JSFuncCall tw2.*``)::

    #!python
    #!/usr/bin/env python
    import github2.client

    ghc = github2.client.Github()

    # This was the trick.  I have too many repos!
    all_repos, page = [], 0
    while True:
        new_repos = ghc.repos.list('ralphbean', page)
        if not new_repos:
            break
        all_repos.extend(new_repos)
        page += 1

    for repo in all_repos:
        if 'tw2' in repo.name:
            print repo.name
