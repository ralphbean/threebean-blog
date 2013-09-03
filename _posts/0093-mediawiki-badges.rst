---
categories: fedora, wiki, badges
date: 2013/09/03 10:50:00
permalink: http://threebean.org/blog/mediawiki-badges
title: Fedora Badges in your Wiki Page
---

In case you missed it, `Ricky Elrod wrote and deployed a mediawiki plugin for
embedding Fedora Badges
<http://blog.elrod.me/blog/2013/09/01/how-to-not-look-like-a-fool-due-to-haproxy/>`_
on your wiki page.  Here's `mine <https://fedoraproject.org/wiki/User:Ralph>`_.

As Ricky wrote above, you can add::

    {{ #fedorabadges: your_fas_username }}

where you want your badges to appear, and::

    {{ #fedorabadgescount: your_fas_username }}

anywhere you want a *count* of your badges to appear.
