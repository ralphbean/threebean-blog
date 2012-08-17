---
categories: python fedora
date: 2012/08/17 11:00:00
permalink: http://threebean.org/blog/atexit-for-threads
title: atexit for threads
---

I ran into some wild stuff the other day while working on `fedmsg
<http://github.com/ralphbean/fedmsg>`_ for Fedora Infrastructure (FI).

tl;dr -> ``atexit`` won't fire for threads.  Objects stored in an instance of
``threading.local`` do get reliably cleaned up, though.  Implementing ``__del__``
on an object there seems to be a sufficient replacement for ``atexit`` in a
multi-threaded environment.

----

**Some Context** --
The goal of fedmsg is to link all the services in FI together with a message
bus.  We're using python (naturally) and zeromq.  `lmacken's <http://lewk.org>`_
`Moksha <http://mokshaproject.net/>`_ is in the mix which lets us swap out
zeromq for AMQP or STOMP if we like.. (we need AMQP in order to get messages
from bugzilla, for instance).

We actually have a `first iteration
<http://fedmsg.readthedocs.org/en/latest/status.html>`_ running in
production now.  You can see `reprs
<https://github.com/ralphbean/fedmsg/blob/develop/fedmsg/text/__init__.py#L58>`_
of the live messages if you hop into ``#fedora-fedmsg`` on freenode.

One of the secondary goals of fedmsg (and the decisive one for this blog post)
is to be as simple as possible to invoke.  If we make sure that our data
models have ``__json__`` methods, then invocation can look like::

    #!python
    import fedmsg
    fedmsg.publish(topic='event', msg=my_obj)

fedmsg does lots of "neat" stuff here.  It:

 - Creates a zeromq context and socket as a singleton to keep around.
 - Changes the topic to ``org.fedoraproject.blog.event``.
 - Converts my_obj to a ``dict`` by calling ``__json__`` if necessary.
 - Cryptographically signs it if the config file says to do so.
 - Sends it out.

The flipside of simplying the API is that we offloaded a lot of complexity to
the configuration in /etc/fedmsg.d/.  i.e., what port? where are the
certificates?  Nonetheless, I'm pretty happy with it.

----

**The Snag** --
fedmsg played nicely in multi-process environments (say, mod_wsgi).  Each
process would pick a different port and nobody stomped on each others resources.
It wasn't until last week that we stumbled into a use case that required a
multi-threaded environment.  Threads fought over the zeromq socket for their
process:  sadness.

Solution:  Hang my singleton wrapper on `threading.local
<http://docs.python.org/library/threading.html#threading.local>`_!  I wrote some
"integration-y" tests and it worked like a charm.

The last problem was cleanup.  I had hitherto been using `atexit.register
<http://docs.python.org/library/atexit.html#atexit.register>`_ to cleanup the
zeromq context and sockets at the end of a process, but it wasn't been called
when threads finished up.  What to do?

First level of evil:  I dove into the source of CPython (for the first time)
looking for thread exit hooks.  No luck.

Second level of evil:  I dove into `inspect
<http://docs.python.org/library/inspect.html>`_.  Could I rewrite the call stack
and inject fedmsg cleanup code at the *end* of my topmost parent's frame?  No
luck (CPython told me "read-only").


----

**The Solution** --
Something, somewhere is either responsibly cleaning up or calling ``del`` on
threading.local's members.

I had simply to add a ``__del__`` method to my
main ``FedmsgContext`` class and everything fell into place at threads' end.
