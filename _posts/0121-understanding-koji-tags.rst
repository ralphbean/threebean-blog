---
categories: fedora, koji, releng, graphviz
date: 2014/11/12 13:07:00
permalink: http://threebean.org/blog/understanding-koji-tags
title: Trying to Understand Koji Tags (i need a picture...)
---

Over the past few days I've been trying to replicate our release-engineering
infrastructure in our staging environment so we can try out changes with less
worry, move faster in the future, etc.  There been `some progress
<https://lists.fedoraproject.org/pipermail/rel-eng/2014-November/018801.html>`_
but there are a *lot* of pieces -- this won't be done for a while.

The latest subject of my efforts has been koji.  I had some authentication
problems off the bat but I got it to the point now so that it is pulling it's
CRL correctly from FAS.  You can edit ``/etc/koji.conf`` and actually point
your builds at it. It only has one builder (all we need) but they'll run and
complete!::

    [koji]
    ;server = http://koji.fedoraproject.org/kojihub
    ;weburl = http://koji.fedoraproject.org/koji
    ;topurl = https://kojipkgs.fedoraproject.org/
    server = http://koji.stg.fedoraproject.org/kojihub
    weburl = http://koji.stg.fedoraproject.org/koji
    topurl = https://kojipkgs.stg.fedoraproject.org/

I even have the ``kojira`` service running now (it is a background service
responsible for rebuilding and maintaining the repos that hang off of
https://koji.fedoraproject.org/repos/ -- notably the ``rawhide/`` one that I'm
interested in for performing fake staging 'composes'.  It is notoriously
absent from `the staging repos <https://koji.stg.fedoraproject.org/repos>`_.)

This led me into the dark nest that is koji tags and targets.  I've been using
them for years to build my packages, but I never really understood how they all
fit together and what was even the difference between a tag and a target. I
wrote the following graph-generating script the try and make sense:

::

    #!python
    #!/usr/bin/env python
    """ koji2graphviz.py - Visualize Koji Tags and their relationships.

    Author:     Ralph Bean <rbean@redhat.com>
    License:    LGPLv2+
    """

    import multiprocessing.pool
    import sys

    from operator import itemgetter as getter

    import koji

    # https://pypi.python.org/pypi/graphviz
    from graphviz import Digraph

    N = 40

    graph_options = {'format': 'png'}
    tags_parent_child = Digraph(
        name='tags_parent_child', comment='Koji Tags, Parent/Child relationships',
        **graph_options)
    tags_groups = Digraph(
        name='tags_groups', comment='Koji Tags and what Groups they are in',
        **graph_options)
    tags_and_targets = Digraph(
        name='tags_and_targets', comment='Koji Tags and Targets',
        **graph_options)

    client = koji.ClientSession('https://koji.fedoraproject.org/kojihub')
    tags = client.listTags()
    for tag in tags:
        tags_parent_child.node(tag['name'], tag['name'])


    def get_relations(tag):
        sys.stdout.write('.')
        sys.stdout.flush()
        idx = tag['id']
        return (tag, {
            'parents': client.getInheritanceData(tag['name']),
            'group_list': sorted(map(getter('name'), client.getTagGroups(idx))),
            'dest_targets': client.getBuildTargets(destTagID=idx),
            'build_targets': client.getBuildTargets(buildTagID=idx),
            'external_repos': client.getTagExternalRepos(tag_info=idx),
        })


    print "getting parent/child relationships with %i threads" % N
    pool = multiprocessing.pool.ThreadPool(N)
    relationships = pool.map(get_relations, tags)
    print
    print "got relationships for all %i tags" % len(relationships)

    print "collating known groups"
    known_groups = list(set(sum([
        data['group_list'] for tag, data in relationships
    ], [])))
    for group in known_groups:
        tags_groups.node('group-' + group, 'Group: ' + group)

    print "collating known targets"
    known_targets = list(set(sum([
        [target['name'] for target in data['build_targets']] +
        [target['name'] for target in data['dest_targets']]
        for tag, data in relationships
    ], [])))
    for target in known_targets:
        tags_and_targets.node('target-' + target, 'Target: ' + target)

    print "building graph"
    for tag, data in relationships:
        for parent in data['parents']:
            tags_parent_child.edge(parent['name'], tag['name'])
        for group in data['group_list']:
            tags_groups.edge(tag['name'], 'group-' + group)
        for target in data['build_targets']:
            tags_and_targets.edge('target-' + target['name'], tag['name'], 'build')
        for target in data['dest_targets']:
            tags_and_targets.edge(tag['name'], 'target-' + target['name'], 'dest')

    print "writing"
    tags_parent_child.render()
    tags_groups.render()
    tags_and_targets.render()
    print "done"

Check out this first beast of a graph that it generates.  It is a mapping of the
parent/child inheritance relationship between tags (you can get at similar
information with the ``$ koji list-tag-inheritance SOME_TAG`` command.

.. image:: http://threebean.org/koji/tags_parent_child.gv.png
   :width: 600px
   :target: http://threebean.org/koji/tags_parent_child.gv.png
   :alt: Koji tag inheritance relationships

This next one shows koji tags and what 'targets' they have relationships with.
There are two kind of relationships here.  A target can be a "destination
target" for a tag or it can be a "build target" for a tag.

Dennis Gilmore tells me that::

    Targets are glue for builds. Targets define the tag used for the buildroot
    and the tag that the resulting build is tagged to.

Trying to unpack that -- take the rawhide target in this graph.  It gets its
buildroot definition from the f22-build tag, and builds that succeed there are
sent to the f22 tag.

.. image:: http://threebean.org/koji/tags_and_targets.gv.png
   :width: 600px
   :target: http://threebean.org/koji/tags_and_targets.gv.png
   :alt: Koji tags and what and_targets they belong to

Anyways, the next step for my compose-in-staging project is to get that
``rawhide-repo-holder`` target setup.  I think kojira will notice that and
start building the appropriate `rawhide/` repo for the next bits down the
pipeline.  Feel free to reuse and modify the graph-generating script above, it
was fun to write, and I hope it's useful to you some day.  Happy Hacking!
