---
categories: fedora, datagrepper, datanommer, postgres, fedmsg
date: 2015/02/27 12:30:00
permalink: http://threebean.org/blog/revisiting-datagrepper-performance
title: Revisiting Datagrepper Performance
---

In Fedora Infrastructure, we run a service somewhat-hilariously called
`datagrepper <https://apps.fedoraproject.org/datagrepper/raw>`_ which lets you
make queries over HTTP about the history of our `message bus
<http://fedmsg.com>`_.  (The service that feeds the database is called
`datanommer <https://github.com/fedora-infra/datanommer>`_.) We recently
crossed the mark of `20 million messages
<https://apps.fedoraproject.org/datagrepper>`_ in the store, and the thing
still works but it has become noticeably slower over time.  This affects other
dependent services:

- The `releng dashboard <https://apps.fedoraproject.org/releng-dash>`_ and
  others make HTTP queries to datagrepper.
- The `fedora-packages app <https://apps.fedoraproject.org/packages>`_ waits on
  datagrepper results to present brief histories of packages.
- The `Fedora Badges backend <https://badges.fedoraproject.org>`_ queries the
  db directly to figure out if it should award badges or not.
- The `notifications frontend <https://apps.fedoraproject.org/notifications>`_
  queries the db to try an display what messages in the past *would have
  matched* a hypothetical set of rules.

I've `written about this chokepoint before
<http://threebean.org/blog/datanommer-database-migrated/>`_, but haven't had
time to really do anything about it... until this week!

Measuring how bad it is
-----------------------

First, some stats -- I wrote this benchmarking script to try a handful of
different queries on the service and report some average response times::

    #!python
    #!/usr/bin/env python
    import requests
    import itertools
    import time
    import sys

    url = 'https://apps.fedoraproject.org/datagrepper/raw/'

    attempts = 8

    possible_arguments = [
        ('delta', 86400),
        ('user', 'ralph'),
        ('category', 'buildsys'),
        ('topic', 'org.fedoraproject.prod.buildsys.build.state.change'),
        ('not_package', 'bugwarrior'),
    ]

    result_map = {}
    for left, right in itertools.product(possible_arguments, possible_arguments):
        if left is right:
            continue
        key = hash(str(list(sorted(set(left + right)))))
        if key in result_map:
            continue

        results = []
        params = dict([left, right])
        for attempt in range(attempts):
            start = time.time()
            r = requests.get(url, params=params)
            assert(r.status_code == 200)
            results.append(time.time() - start)

        # Throw away the max and the min (outliers)
        results.remove(min(results))
        results.remove(min(results))
        results.remove(max(results))
        results.remove(max(results))

        average = sum(results) / len(results)
        result_map[key] = average

        print "%0.4f    %r" % (average, str(params))
        sys.stdout.flush()

The results get printed out in two columns.

- The leftmost column is the average number of seconds it takes to make a
  query (we try 8 times, throw away the shortest and the longest and take the
  average of the remaining).
- The rightmost column is a description of the query arguments passed to
  datagrepper.  Different kinds of queries take different times.

This first set of results are from our production instance as-is::

    7.7467    "{'user': 'ralph', 'delta': 86400}"
    0.6984    "{'category': 'buildsys', 'delta': 86400}"
    0.7801    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'delta': 86400}"
    6.0842    "{'not_package': 'bugwarrior', 'delta': 86400}"
    7.9572    "{'category': 'buildsys', 'user': 'ralph'}"
    7.2941    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'user': 'ralph'}"
    11.751    "{'user': 'ralph', 'not_package': 'bugwarrior'}"
    34.402    "{'category': 'buildsys', 'topic': 'org.fedoraproject.prod.buildsys.build.state.change'}"
    36.377    "{'category': 'buildsys', 'not_package': 'bugwarrior'}"
    44.536    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'not_package': 'bugwarrior'}"

Notice that a handful of queries are under one second but some are unbearably
long.  A seven second response time is too long, and a 44-second response time
is **way** too long.

Setting up a dev instance
-------------------------

I grabbed `the dump of our production database
<https://infrastructure.fedoraproject.org/infra/db-dumps/>`_ and imported it
into a fresh postgres instance in our private cloud to mess around.
Before making any further modifications, I ran the benchmarking script again
on this new guy and got some different results::

    5.4305    "{'user': 'ralph', 'delta': 86400}"
    0.5391    "{'category': 'buildsys', 'delta': 86400}"
    0.4992    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'delta': 86400}"
    4.5578    "{'not_package': 'bugwarrior', 'delta': 86400}"
    6.4852    "{'category': 'buildsys', 'user': 'ralph'}"
    6.3851    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'user': 'ralph'}"
    10.932    "{'user': 'ralph', 'not_package': 'bugwarrior'}"
    9.1895    "{'category': 'buildsys', 'topic': 'org.fedoraproject.prod.buildsys.build.state.change'}"
    14.950    "{'category': 'buildsys', 'not_package': 'bugwarrior'}"
    12.044    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'not_package': 'bugwarrior'}"

A couple things are faster here:

- No ssl on the HTTP requests (almost irrelevant)
- No other load on the db from other live requests (likely irrelevant)
- The db was freshly imported (the `last time we moved the db server
  <http://threebean.org/blog/datanommer-database-migrated/>`_ things got
  magically faster.  I think there's something about the way that postgres
  stores stuff internally that when you freshly import the data, it is
  organized more effectively.  I have no data or real know-how to support this
  claim though).

Experimenting with indexes
--------------------------

I first tried `adding indexes
<https://github.com/fedora-infra/datanommer/blob/feature/indices/datanommer.models/alembic/versions/5a167589eb8e_add_category_index.py>`_
on the ``category`` and ``topic`` columns of the ``messages`` table (which are
common columns used for filter operations).  We already have an index on the
``timestamp`` column, without which the whole service is just unusable.

Some results after adding those::

    0.1957    "{'user': 'ralph', 'delta': 86400}"
    0.1966    "{'category': 'buildsys', 'delta': 86400}"
    0.1936    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'delta': 86400}"
    0.1986    "{'not_package': 'bugwarrior', 'delta': 86400}"
    6.6809    "{'category': 'buildsys', 'user': 'ralph'}"
    6.4602    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'user': 'ralph'}"
    10.982    "{'user': 'ralph', 'not_package': 'bugwarrior'}"
    3.7270    "{'category': 'buildsys', 'topic': 'org.fedoraproject.prod.buildsys.build.state.change'}"
    14.906    "{'category': 'buildsys', 'not_package': 'bugwarrior'}"
    7.6618    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'not_package': 'bugwarrior'}"

Response times are faster in the cases you would expect.

Those columns are relatively simple one-to-many relationships.  A message has
one topic, and one category.  Topics and categories are each associated with
many messages.  There is no ``JOIN`` required.

Handling the many-to-many cases
-------------------------------

Speeding up the queries that require filtering on users and packages is more
tricky.  They are many-to-many relations -- each user is associated with
multiple messages and a message may be associated with many users (or many
packages).

I did some research, and through trial-and-error found that adding a `composite
primary key on the bridge tables
<https://github.com/fedora-infra/datanommer/blob/feature/indices/datanommer.models/alembic/versions/19bb834d6f9_add_users_composite_pkey.py>`_
gave a nice performance boost.  See the results here::

    0.2074    "{'user': 'ralph', 'delta': 86400}"
    0.2091    "{'category': 'buildsys', 'delta': 86400}"
    0.2099    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'delta': 86400}"
    0.2056    "{'not_package': 'bugwarrior', 'delta': 86400}"
    1.4863    "{'category': 'buildsys', 'user': 'ralph'}"
    1.4553    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'user': 'ralph'}"
    1.8186    "{'user': 'ralph', 'not_package': 'bugwarrior'}"
    3.5525    "{'category': 'buildsys', 'topic': 'org.fedoraproject.prod.buildsys.build.state.change'}"
    10.9242    "{'category': 'buildsys', 'not_package': 'bugwarrior'}"
    3.5214    "{'topic': 'org.fedoraproject.prod.buildsys.build.state.change', 'not_package': 'bugwarrior'}"

The best so far!  That one 10.9 second query is undesirable, but it also
makes sense:  we're asking it to first filter for all buildsys messages (the
spammiest category) and then to prune those down to only the builds (a proper
subset of that category).  If you query *just* for the builds by topic and omit
the category part (which is what you want anyways) the query takes 3.5s.

All around, I see a 3.5x speed increase.

Rolling it out
--------------

The code is `set to be merged into datanommer
<https://github.com/fedora-infra/datanommer/pull/76>`_ and I wrote `an ansible
playbook to orchestrate pushing the change out
<https://infrastructure.fedoraproject.org/cgit/ansible.git/tree/playbooks/manual/upgrade/datanommer.yml>`_.
I'd push it out now, but we `just entered the infrastructure freeze
<https://lists.fedoraproject.org/pipermail/infrastructure/2015-February/015548.html>`_
for the Fedora 22 Alpha release.  Once we're through that and all thawed, we
should be good to go.
