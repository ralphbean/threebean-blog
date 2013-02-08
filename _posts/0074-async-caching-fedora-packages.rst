---
categories: python, fedora, ruby, cache
date: 2013/02/07 12:00:00
permalink: http://threebean.org/blog/async-caching-fedora-packages
title: Async Caching & the Fedora Packages App
---

**Backstory**

`Luke (lmacken) Macken <http://lewk.org>`_,
`John (J5) Palmieri <http://www.j5live.com/>`_, and
`Máirín (mizmo/miami) Duffy <http://blog.linuxgrrl.com/>`_ created the `Fedora
Packages webapp <https://apps.fedoraproject.org/packages/>`_; its initial
release was about this time last year at `FUDCon Blacksburg
<https://fedoraproject.org/wiki/Archive:FUDCon:Blacksburg_2012>`_.  It is cool!

Over the summer, I wrote a `python api <http://pkgwat.rtfd.org>`_ and cli tool
called `pkgwat <https://apps.fedoraproject.org/packages/pkgwat>`_ to query it.
`David Davis <https://github.com/daviddavis>`_ then wrote his own `ruby bindings
<https://github.com/daviddavis/pkgwat>`_ which now `power
<https://github.com/zuhao/isitfedoraruby/pull/31>`_ the `Is It Fedora Ruby?
<http://www.isitfedoraruby.com/>`_ webapp.

In late 2012 as part of `another scheme
<https://fedorahosted.org/fedoracommunity/ticket/381>`_, I redirected the
popular `https://bugz.fedoraproject.org/$SOME_PACKAGE
<https://bugz.fedoraproject.org/kernel>`_ alias from an older app to
the packages app's `bug list interface
<https://apps.fedoraproject.org/packages/kernel/bugs/all>`_.

There was a problem though:  developers reported that the page `didn't work
<http://lists.fedoraproject.org/pipermail/devel/2012-December/174956.html>`_
and was `too slow
<http://lists.fedoraproject.org/pipermail/devel/2012-December/175008.html>`_!

Darn.

----

**Caching**

There were a number of small bugs (including an ssl timeout when querying `Red
Hat's bugzilla instance <https://bugzilla.redhat.com>`_).  Once those were
cleared there remained the latency issue.  For packages like the `kernel
<https://apps.fedoraproject.org/packages/kernel/bugs/all>`_, our shiny webapp
absolutely crawled; it would sometimes take a minute and a half for the AJAX
requests to complete.  We were confused -- caching had been written into the
app from day one, so.. what gives?

To my surprise, I found that our app servers were being blocked from talking to
our memcached servers by iptables (I'm not sure how we missed that one).  Having
flipped that bit, there was somewhat of an improvement, but.. we could do
better.

----

**Caching with dogpile.cache**

I had read Mike Bayer's `post on dogpile.cache back in Spring 2012
<http://techspot.zzzeek.org/2012/04/19/using-beaker-for-caching-why-you-ll-want-to-switch-to-dogpile.cache/>`_.
We had been using Beaker, so I decided to try it out.  It worked!  It
was cool...

...and I was completely mistaken about what it did.  Here is what it actually
does:

1. When a request for a cache item comes in and that item doesn't exist, it
   blocks while generating that value.
2. If a second request for the same item comes in before the value has finished
   generating, the second request blocks and simply waits for the first request's
   value.
3. Once the value is finished generating, it is stuffed in the cache and both
   the first and second threads/procs return the value "simultaneously".
4. Subsequent requests for the item happily return the cached value.
5. Once the expiration passes, the value remains in the cache but is now
   considered "stale".
6. The next request will behaves the same as the very first:  it will block while
   regenerating the value for the cache.
7. Other requests that come in while the cache is being refreshed now do not
   block, but happily return the stale value.  This is awesome.  When a value
   becomes stale, only one thread/proc is elected to refresh the cache, all
   others return snappily (happily).

The above is what dogpile.cache actually does (to the best of my story-telling
abilities).

In my *imagination*, I thought that step number `vi` didn't actually
block.  I thought that ``dogpile.cache`` would spin off a background thread to
refresh the cache asynchronously and that number `vi`'s request would return
immediately.  This would mean that once cache entries had been filled, the app
would feel quick and responsive forever!

It did not work that way, so I `submitted a patch
<https://bitbucket.org/zzzeek/dogpile.core/pull-request/2>`_.  Now it does.  :)

----

**Threads**

::

    A programmer had a problem.
    He thought to himself, "I know, I'll solve it with threads!".
    has Now problems. two he

With dogpile.cache now behaving magically and the Fedora Packages webapp patched
to take advantage of it, I deployed a new release to staging the day before
FUDCon and then again to production at FUDCon on Saturday, January 19th, 2013.
At this point our memcached servers promptly `lost their minds
<http://threebean.org/sad_memcached.png>`_.

.. image::  http://threebean.org/sad_memcached.png
   :target: http://threebean.org/sad_memcached.png

Mike Bayer `sagely warned
<https://bitbucket.org/zzzeek/dogpile.core/pull-request/2/create-new-values-in-a-background-thread/diff#comment-75184>`_
that the approach was creepy.

Each of those threads weren't cleaning up their memcached connections properly
and enough were being created that the number of concurrent connections was
bringing down the cache daemon.  To make it all worse, enough changes were
made rapidly enough at FUDCon that
isolating what caused this took some time.  Other environment-wide FUDCon changes
to my `fedmsg <http://fedmsg.com>`_ system were also causing unrelated issues and I spent
the following week putting out all kinds of fires in all kinds of contexts in
what seemed like a never-ending rush.  (New ones were started in the
process too, like unearthing a PyCurl issue in python-fedora, porting the
underlying mechanism to python-requests, only to encounter `bundling
<https://bugzilla.redhat.com/show_bug.cgi?id=904623>`_, `compatibility
<https://bugzilla.redhat.com/show_bug.cgi?id=906924>`_, and `security
<https://bugzilla.redhat.com/show_bug.cgi?id=904614>`_ `bugs
<https://bugzilla.redhat.com/show_bug.cgi?id=855322>`_ there.)

----

**A long-running queue**

During that rush, I reimplemented my ``async_creator``.

Where before it would start up a new thread, do the work, update
the cache, and release the mutex, now it
would simply drop a note in a redis queue with `python-retask
<http://retask.readthedocs.org/en/latest/>`_.
With that came a corresponding
`worker daemon
<https://github.com/fedora-infra/fedora-packages/blob/develop/fedoracommunity/connectors/api/worker.py>`_
that picks those tasks off the queue one at a time, does the work, refreshes
the cache and releases the distributed dogpile lock before moving on to the next
item.

The app seems to be working well now.  Any issues?  Please `file them
<https://github.com/fedora-infra/fedora-packages/issues/>`_ if so.  I am going
to take a nap.
