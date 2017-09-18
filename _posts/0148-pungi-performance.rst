---
categories: fedora, factory2
date: 2017/09/01 21:45:00
permalink: http://threebean.org/blog/pungi-performance
title: Pungi Performance, Profiling?
---

Happy Flockery!

This might not be new to others, but I wanted to identify which parts of the compose process were slow, so I wrote a `little script
<http://pagure.io/analyze-compose>`_. If you didn't know, our compose process
is `broken up into phases
<http://lsedlarpungi.readthedocs.io/en/master/phases.html>`_ some of which run
in serial, others of which run in parallel.  The composes take a long time, and
speeding them up would be great.

::

	#!python
	#!/usr/bin/env python3
	""" Usage:  python3 analyze-compose.py Fedora-27-20170901.n.1 """

	import operator
	import sys

	import requests
	import dogpile.cache

	cache = dogpile.cache.make_region().configure(
		'dogpile.cache.dbm',
		expiration_time=500,
		arguments=dict(filename='/var/tmp/datagrepper-cache.dbm')
	)

	# Fedora-27-20170901.n.1
	target = sys.argv[-1]

	@cache.cache_on_arguments()
	def get_messages(target):
		url = 'https://apps.fedoraproject.org/datagrepper/raw'
		params = dict(
			category='pungi',
			rows_per_page=100,
			contains=target,
			delta=1278000,
		)
		print("Querying %r %r" % (url, params))
		response = requests.get(url, params=params)
		return [m for m in response.json()['raw_messages']]


	if __name__ == '__main__':
		print('Analyzing compose %r' % target)
		messages = get_messages(target)
		starts, stops = {}, {}
		for message in messages:
			if message['topic'].endswith('compose.status.change'):
				continue
			if message['topic'].endswith('compose.phase.start'):
				starts[message['msg']['phase_name']] = message['timestamp']
			if message['topic'].endswith('compose.phase.stop'):
				stops[message['msg']['phase_name']] = message['timestamp']

		deltas = {}
		for phase in starts:
			if phase not in stops:
				continue
			deltas[phase] = stops[phase] - starts[phase]

		deltas = list(deltas.items())
		deltas.sort(key=operator.itemgetter(1), reverse=True)
		for phase, delta in deltas:
			print("{0:20} {1:.2f} hours".format(phase, delta / 60.0 / 60.0))


This script prints out stats about all of the phases. Take a look at this
compose from a few days ago and focus in on just one phase::

	#!bash
	❯ ./analyze-compose.py Fedora-27-20170830.n.0
	Analyzing compose 'Fedora-27-20170830.n.0'
	[snip]
	createrepo           8.50 hours
	[snip]

That ``createrepo`` phase is gigantic!

After `one <https://pagure.io/pungi-fedora/pull-request/341>`_ or `two
<https://pagure.io/pungi-fedora/pull-request/340>`_ patches we were able to get
it down a little tighter the next day::

	#!bash
	./analyze-compose.py Fedora-27-20170901.n.1
	Analyzing compose 'Fedora-27-20170901.n.1'
	[snip]
	createrepo           0.33 hours
	[snip]

``createrepo`` phase -- greatly improved.

The next one that jumps out at me is the ``pkgset`` phase.  What's going on there?

I'm not sure yet but have `posted a patch
<https://pagure.io/pungi/pull-request/727>`_ introducing more logging so we can
get a feel for it.
