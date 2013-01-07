---
categories: moksha, openshift, fedora, python
date: 2013/01/07 15:50:00
permalink: http://threebean.org/blog/moksha-on-openshift
title: WebSockets on OpenShift (Moksha in the Cloud)
---

I've been waiting on the OpenShift team to crack `the WebSocket nut
<http://red.ht/109BtLD>`_ for a while and they finally `got it back in December
<http://red.ht/XfiFVP>`_.  To try it out, I tried to set up the `Moksha Demo
Dashboard <http://threebean.org/blog/the-moksha-demo-dashboard/>`_ on two
different gears.

It wasn't too tricky.  I created two OpenShift "DIY"-type apps, `one for the WSGI
app <https://github.com/mokshaproject/openshift-mokshademo>`_ and `another for
the WebSocket server (the moksha-hub)
<https://github.com/mokshaproject/openshift-mokshahub>`_.  All the work in those
two repos is done in the ``.openshift/action_hooks`` directories (the code is
actually just installed from `PyPI <http://pypi.python.org/pypi/mdemos.server>`_).
Additionally, the ``diy/development.ini`` files hold all the configuration.

It's live now at http://mokshademo-threebean.rhcloud.com/ but it's our same demo
`as before <http://moksha.csh.rit.edu>`_.  Other apps still in the development
pipeline should be more interesting when they arrive.

.. image:: http://threebean.org/moksha-screenshot-2012-10-25.png
   :width: 600px
