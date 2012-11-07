---
categories: gnome, python, fedora, github
date: 2012/11/07 12:30:00
permalink: http://threebean.org/blog/search-github-from-gnome-shell
title: Search github from the gnome-shell
---

After `the first one <http://bit.ly/Ra0lLC>`_, I wrote another search provider
for gnome-shell >= 3.6 in python, this time for flipping through your github
repositories.

Screencast `on vimeo <https://vimeo.com/53014796>`_.  Source `on github
<http://bit.ly/PDIy1g>`_.  Fedora package review `in bugzilla
<http://bit.ly/TIzMQ4>`_.

A standing problem is how to prompt the user for their authentication tokens.
Right now, I require that the user maintain a ``~/.search-github`` file by hand
including their github username and password.  Ugly, but it works.

Best, I think, would be to integrate with GNOME Online Accounts.  However,
`it appears that I cannot write a plugin for that
<http://debarshiray.wordpress.com/2012/10/06/goa-why-it-is-the-way-it-is/>`_.

What other approaches are available?  I could use a modal prompt kind of
like when NetworkManager prompts you for a wifi or VPN password and could then save
credentials to the keyring.  I haven't yet figured out how to create that
prompt yet though, so if anyone knows.. kindly point me in the right direction.

Other ideas?
