---
categories: fedora,fedmsg,datagrepper,widgetry
date: 2014/04/01 14:30:00
permalink: http://threebean.org/blog/a-fedmsg-widget-for-your-site
title: A fedmsg widget for your site
---

Not an April Fool's joke: more cool `fedmsg <http://fedmsg.com>`_ tools from
the `Fedora Infrastructure Team
<https://fedoraproject.org/wiki/Infrastructure>`_: the `datagrepper
<https://apps.fedoraproject.org/datagrepper/>`_ app now provides a little
`self-expanding javascript widget
<https://apps.fedoraproject.org/datagrepper/widget>`_ that you can embed on
your blog or website.  I have it installed on `my blog
<http://threebean.org>`_; if you look there (here?), it should show up on the
right hand side of the screen.

Here's the example from the `datagrepper docs <https://apps.fedoraproject.org/datagrepper/widget>`_::

    <html>
      <body>
        <h1>My Site</h1>
        <p class="lead">Welcome to my site.</p>
        <p>Here is my latest Fedora activity:</p>

        <script
          src="https://apps.fedoraproject.org/datagrepper/widget.js?css=true"
          data-user="ralph"
          data-rows_per_page="40">
        </script>

        <footer>Happy Hacking!</footer>
      </body>
    </html>

Just copy-and-paste that into a file called ``testing-stuff.html`` on your
machine, and then open that file in your browser.  You should see something
like this:

.. image:: http://threebean.org/blog/static/images/datagrepper-widget-user.png
   :width: 600px

----

Like `the docs <https://apps.fedoraproject.org/datagrepper/widget>`_ say, you
can change the ``data-`` attributes on the ``<script>`` tag to perform
different kinds of queries.  For instance, the following would render a widget
showing only Bodhi events about the Firefox package::

    <script
      src="https://apps.fedoraproject.org/datagrepper/widget.js?css=true"
      data-category="bodhi"
      data-package="firefox"
      data-rows_per_page="20">
    </script>

You might want to include such a thing on a status page for a project you're
working on.

.. image:: http://threebean.org/blog/static/images/datagrepper-widget-bodhi.png
   :width: 600px

----

You can make queries about all the fedmsg topics (see the fedmsg docs for the
`full list <http://fedmsg.com/en/latest/topics/>`_), topics like
``org.fedoraproject.prod.fedbadges.badge.award`` which would render a feed of
the latest `Fedora Badges <https://badges.fedoraproject.org>`_ awards::

    <script
      src="https://apps.fedoraproject.org/datagrepper/widget.js?css=true"
      data-topic="org.fedoraproject.prod.fedbadges.badge.award"
      data-rows_per_page="40">
    </script>

.. image:: http://threebean.org/blog/static/images/datagrepper-widget-badges.png
   :width: 600px

Please let me know in ``#fedora-apps`` on freenode if you have any questions
(or if you find some cool use for it -- I love hearing that stuff).
