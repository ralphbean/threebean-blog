---
categories: fedora, datanommer, datagrepper, fedmsg
date: 2013/05/14 13:30:00
permalink: http://threebean.org/blog/new-datagrepper-api
title: Querying fedmsg history
---

Yesterday, `Ian Weller <http://ianweller.org/>_` and I got the first
iteration of "datagrepper" into production.  It is a JSON api that lets you
query the history of the `fedmsg bus <http://fedmsg.com>`_.
In case you're confused.. it is related to, but not the same thing as
`"datanommer" <http://threebean.org/blog/datanommer-and-fedmsg-activity/>`_.
You can check out the *datagrepper* docs on its `index page
<https://apps.fedoraproject.org/datagrepper>`_ as well as on its `reference
page <https://apps.fedoraproject.org/datagrepper/reference>`_.

It is another building block.  With it, we can now:

- Use it as a reliability resource for other fedmsg projects.

  - Say you have a daemon that listens for fedmsg messages to act on...
    but it crashes.  When it gets restarted it can ask datagrepper "What
    messages did I miss since this morning at 4:03am?" and catch up on those
    as it can.

- Build apps that query it to show "the latest so many messages
  that meet such and such criteria."

  - Imagine an HTML5 mobile app that shows you the latest of anything
    and everything in Fedora.  (`pingou <http://blog.pingoured.fr/>`_ is
    at work on this).
  - Imagine package-centric UI widgets that show the latest Fedora-wide
    events pertaining to a certain package.  We could embed them in the
    `Fedora Packages <https://apps.fedoraproject.org/packages/>`_ app.
  - Imagine user-centric UI widgets that show the latest activity of
    developers.  You could embed yours in your blog or wiki page.

- Statistics!  The whole dataset is available to you and updated in
  real time.  Can you tell any cool stories with it?

It is, like I mentioned, an initial release so please be gentle.  We
have a big `list of plans and bugs
<https://github.com/fedora-infra/datagrepper/issues>`_ to crack on.
If you run into issues or simply have questions, feel free to `file
a bug <https://github.com/fedora-infra/datagrepper/issues/new>`_ or
ping us in ``#fedora-apps`` on freenode.
