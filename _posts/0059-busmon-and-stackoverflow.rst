---
categories: fedora, fedmsg, busmon
date: 2012/10/05 21:40:00
permalink: http://threebean.org/blog/busmon-and-stackoverflow
title: busmon and Stack Overflow licensing.
---

Today, I was working on `busmon <https://apps.fedoraproject.org/busmon>`_
and trying to minimize some of the spam it was publishing back to the `fedmsg
<http://fedmsg.rtfd.org>`_ bus.  This amounted to cutting out some server-side code
that used `pygments <http://pygments.org/>`_ to produce styled html markup and
replacing it with client-side code that did approximately the same thing.

`@lmacken <http://twitter.com/lmacken>`_ found `this Stack Overflow piece
<http://stackoverflow.com/questions/4810841/json-pretty-print-using-javascript>`_
that did just about what I needed.  Like any reasonable person, I `copied and
pasted
<https://github.com/ralphbean/busmon/commit/1d0506f73da15d16dbf577f59f73583dc6e2a12b>`_
and was satisfied.

**Licensing!**  Hold the phone!  Turns out that `content on Stack Overflow is licensed
CC-BY-SA-3.0 <http://en.wikipedia.org/wiki/Stack_Overflow>`_.  By my reading, code
posted there is therefore `incompatible with GPL code
<http://www.gnu.org/licenses/license-list.html#ccbysa>`_.

Wild, right?

*Denouement* -> I ended up `rewriting it my way
<https://github.com/ralphbean/busmon/commit/6ad3a7d70e1c5b42be384df0709eb843bf21b5d7>`_
just to get on with it.
