---
categories: python testing toscawidgets turbogears
date: 2012/06/22 18:00:00
permalink: http://threebean.org/blog/sieve
title: In which I avoid the inverse unicode sandwich
---

**Problem #1** - I need to test tons of HTML output for correctness (because I
maintain `toscawidgets2 <http://toscawidgets.org>`_).
That output varies slightly because ``tw2`` supports five different
templating languages (mako, genshi, jinja2, kajiki, and chameleon).  Using
double-equals (``==``) just won't do it.

**Solution #1** - We used `strainer <http://pypi.python.org/pypi/strainer>`_.  It
works!

**Problem #2** - Imagine porting `this <http://bit.ly/O57MFF>`_ to Python 3.  Yes,
that's right.  The encoding is sniffed by hand and then used to encode
regular expressions; these are in turn applied to parse XML.
Think "`inverse unicode sandwich <http://bit.ly/O58xi7>`_ with a side of
`Cthulhu <http://bit.ly/O58lzf>`_."

**Solution #2** - I wrote `sieve <http://pypi.python.org/pypi/sieve>`_: a baby
module child of one corner of FormEncode and another corner of strainer.  It
`works on pythons 2.6, 2.7, and 3.2
<http://travis-ci.org/#!/ralphbean/sieve>`_.  If you like, you may use it::

    #!python
    >>> from sieve.operators import eq_xml, in_xml
    >>> a = "<foo><bar>Value</bar></foo>"
    >>> b = """
    ... <foo>
    ...     <bar>
    ...         Value
    ...     </bar>
    ... </foo>
    ... """
    >>> eq_xml(a, b)
    True
    >>> c = "<html><body><foo><bar>Value</bar></foo></body></html"
    >>> in_xml(a, c)  # 'needle' in a 'haystack'
    True

p.s. -- I looked into `xmldiff <http://pypi.python.org/pypi/xmldiff>`_.
Awesome!

