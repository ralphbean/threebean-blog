---
categories: moksha, python, fedora
date: 2012/10/25 16:18:00
permalink: http://threebean.org/blog/the-moksha-demo-dashboard
title: The Moksha Demo Dashboard
---

Just writing to show off how easy it is to stand up the `moksha demo dashboard
<http://moksha.csh.rit.edu>`_ these days (it used to be kind of tricky).

.. image:: http://threebean.org/moksha-screenshot-2012-10-25.png
   :width: 600px

First, install some system dependencies if you don't already have them::

    sudo yum install zeromq zeromq-devel python-virtualenvwrapper

Open two terminals.  In the **first** one run::

    mkvirtualenv demo-dashboard
    pip install mdemos.server mdemos.menus mdemos.metrics
    wget https://raw.github.com/mokshaproject/mdemos.server/master/development.ini
    paster serve --reload development.ini

And in the **second** one run::

    workon demo-dashboard
    moksha-hub

"Easy."  Point your browser at http://localhost:8080/ for `action`.

*p.s.* -- In other news, I got `fedmsg <http://fedmsg.com>`_ working with
`zeromq-3.2 <https://apps.fedoraproject.org/packages/zeromq3>`_ in
our staging infrastructure yesterday.  It required `this patch
<https://github.com/smira/txZMQ/pull/35>`_ to python-txzmq
That one aside, python-zmq and php-zmq "just worked" in ``epel-test``.  If
you're writing zeromq code, you probably want to read `this porting guide
<http://www.zeromq.org/docs:3-1-upgrade>`_.
