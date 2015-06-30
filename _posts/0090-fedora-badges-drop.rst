---
categories: fedora, badges, fedmsg
date: 2013/08/28 09:25:00
permalink: http://threebean.org/blog/fedora-badges-launch
title: Fedora Badges Launch
---

.. image:: http://oddshocks.com/presentations/fedora_badges/badges_fan.png
   :height: 164px
   :width: 290px

We launched the new `Fedora Badges <https://badges.fedoraproject.org>`_ webapp
two weeks ago at `Flock <https://flocktofedora.org>`_, the Fedora Contributor's
Conference.  It went over really well; the success was kind of stunning.

If you haven't yet, check out `the site <https://badges.fedoraproject.org>`_.
`The gist <https://badges.fedoraproject.org/about>`_ is that that frontend web
interface is fed by a backend `"badge awarder"
<https://github.com/fedora-infra/fedbadges>`_ which sits watching the fedmsg
bus.  As community members go about contributing to Fedora and interacting with
infrastructure systems, they trigger the publication of new fedmsg messages.
Upon receiving those messages, the badge awarder then makes a number of
comparisons to determine if the person in question should receive this or that
badge.

.. image:: https://badges.fedoraproject.org/pngs/irc-speak-up.png
   :height: 256px
   :width: 256px

Since the launch, we've noticed an uptick on the `fedmsg <http://fedmsg.com>`_
bus; there has been a definite increase in community activity in certain
corners.  Just check out the `Fedora Tagger
<https://apps.fedoraproject.org/tagger>`_ votes.

.. image:: http://threebean.org/fedoratagger-usage-2013-08-27.svg

To generate the above chart, I wrote a little tool which you can find `here
<https://github.com/fedora-infra/fedora-stats-tools>`_.  It uses the `datagrepper
API <https://apps.fedoraproject.org/datagrepper>`_, about which I've `written
before <http://threebean.org/blog/category/datagrepper/>`_.

Writing that gave us the crazy idea to add datagrepper stats to a ``zodbot`` command.
Check out this IRC log from ``#fedora-apps``::

     threebean | .quote BOD monthly
        zodbot | BOD, bodhi -13.31% over the month preceding this one
        zodbot |      ▄▅▆▂▁▂▄▃▄▃▁▂▄▃▃█▅▆▁▄▃▃▂▂▆▄▃▄▂▃▃▅▂▁▃▄▃▅▃▂▄▅▄▂▁▁▁▆▅▄  ⤆ over month
        zodbot |      ↑ 21:01 UTC 07/28                                ↑ 21:01 UTC 08/27

FWIW, ``zodbot`` also got a ``.badges FAS_USER`` command now, too::

    threebean | .badges ralph
       zodbot | ralph has unlocked 36 Fedora Badges

.. image:: https://badges.fedoraproject.org/pngs/design-def-keepin-fedora-beautiful-f20.png
   :height: 256px
   :width: 256px

Lots of people have asked if they can embed their badges on their own blog or
on the wiki or frontend app doesn't provide the tools directly, but we do
allow you to export your badges to Mozilla's `Open Badges Backpack
<http://backpack.openbadges.org>`_ and *they* provide `some tools for embedding
your badges elsewhere
<https://github.com/mozilla/openbadges/wiki/Open-Badges-related-widgets>`_.

On *our* badges app, click the *Export Badges* button on your profile, login
via Mozilla's "Persona" with your ``FASUSERNAME@fedoraproject.org`` email
address, and create custom badge displays there.

Ricky Elrod whipped up this `pretty sweet mediawiki plugin
<https://github.com/CodeBlock/mw-FedoraBadges>`_ but there is `some debate
<https://fedorahosted.org/fedora-infrastructure/ticket/3946>`_ about where we
should start centering user profiles.  It raises an interesting point, though,
that up to this point we have not had nice person-centric view of the Fedora
Community before (it has always been package-centric or update-centric or
something else..)

.. image:: https://badges.fedoraproject.org/pngs/pkgdb-partners-in-crime.png
   :height: 256px
   :width: 256px

(There are still `bugs to fix <https://github.com/fedora-infra/tahrir/issues>`_
in the stack, but...) The big projects now are to 1) *refine badge ideas* and to 2)
produce art for new badges.

We have an `issue tracker <https://fedorahosted.org/fedora-badges>`_ just for
new badge ideas, but take a look at `this report
<https://fedorahosted.org/fedora-badges/query?has_complete_yaml=Full%2C+needs+review&status=accepted&status=assigned&status=new&status=reopened&has_artwork=None&type=New+badge+idea&or&has_complete_yaml=Full%2C+needs+review&status=accepted&status=assigned&status=new&status=reopened&has_artwork=Concept&type=New+badge+idea&or&has_complete_yaml=Approved+%28badges+admins+only%29&status=accepted&status=assigned&status=new&status=reopened&has_artwork=None&type=New+badge+idea&or&has_complete_yaml=Approved+%28badges+admins+only%29&status=accepted&status=assigned&status=new&status=reopened&has_artwork=Concept&type=New+badge+idea&group=has_complete_yaml&col=id&col=summary&col=has_complete_yaml&col=has_artwork&col=priority&col=time&col=concept_review_passed&report=11&order=priority>`_
in particular.  It lists proposals which have *everything they need* (an idea,
a name, some code to make it real) *except* for badge art.  Can you put
something together?  Take a look at `mizmo's design scheme for badges
<http://blog.linuxgrrl.com/2013/07/23/fedora-badgers/>`_ to get started.

.. image:: https://badges.fedoraproject.org/pngs/badger-03.png
   :height: 256px
   :width: 256px

Shout outs (in order of appearance) are due to `rossdylan
<http://blog.helixoide.com/>`_ for laying the groundwork last summer, to
`oddshocks <http://oddshocks.com/>`_ for lifting the web frontend to go-time
status, to `jenneh <http://jennk.com/>`_ for UI mockups and the original badge
designs, to `mizmo <http://blog.linuxgrrl.com/>`_ for the badge design scheme
and countless badge designs, to `adamw <http://happyassassin.net>`_ for the
badge idea submission process and for triaging the avalanche, to `ryanlerch
<http://www.ryanlerch.org/blog/>`_ and `decause <https://github.com/decause>`_
for art, to those who filed new badge ideas on the `issue tracker
<https://fedorahosted.org/fedora-badges>`_ and anyone else in ``#fedora-apps``
I may have missed.

Some of us from ``#fedora-apps`` are going to be presenting on Mozilla's `Open
Badges Community <http://community.openbadges.org/>`_ call on `September 11th
<https://lists.fedoraproject.org/pipermail/badges/2013-August/000002.html>`_.
Feel free to call in and join us there if you want to talk Fedora Badges.

----

Lastly, I've got to apologize if I've been slow to respond or too short in my
manner with anyone the past few weeks... my TODO list deficit has just gone
through the roof.
