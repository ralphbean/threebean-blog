---
categories: fedora, bodhi
date: 2014/06/09 09:35:00
permalink: http://threebean.org/blog/bodhi2-fad-hollaback
title: Bodhi2 FAD Reportback
---

In case you missed it, the `Bodhi2 FAD
<https://fedoraproject.org/wiki/FAD_Bodhi2_Taskotron_2014>`_ was last week.

Here's a quick rundown of the things I was able to contribute:

- Each URL in Bodhi2 (any page you look at in the web URL) will also be an api
  endpoint for JSON and JSONP.  This should hopefully make it easier to deduce
  the API from the pages you interact with.  Built-in JSONP support means that
  our other webapps can query bodhi asynchronously from javascript clients.
  (Almost) every page should also serve an RSS feed from the same url as well.
  Just hit it with an `'Accept': 'application/rss'` header.

- I resurrected the search field on the front page from bodhi1 (now with
  autocomplete) via `typeahead.js <http://twitter.github.io/typeahead.js/>`_.
  At present, it can search updates, comments, and users.

- Modern Fedora chrome and frontpage dashboard: I copied the style over from
  `fmn <https://apps.fedoraproject.org/notifications>`_ which you may have seen
  from `a screencast <http://threebean.org/blog/bodhi2-karma-system-preview/>`_
  a few months ago.  We expanded that to other pages.. but then Ricky Elrod
  took it to the next level

- fedmsg hooks from bodhi1 have been added back in to bodhi2 now so we should
  get the same level and structure of messaging as we have now (plus some more
  events from the backend masher process).

- The bulk of my time was spent in javascript land on the "new update form".
  It's pretty streamlined now compared to the bodhi1 incarnation.  More on that
  as we get closer to launching a staging instance.

By the numbers
--------------

It was among the most productive sprints I've ever been a part of.  The `commit
activity graph <https://github.com/fedora-infra/bodhi/graphs/commit-activity>`_
on github tells us:

- 25 commits on Sunday
- 47 commits on Monday
- 43 commits on Tuesday
- 55 commits on Wednesday
- 6 commits on Thursday (we were packing up to leave).

None of those stats count commits to other repos related to bodhi2, like `this
feature
<https://github.com/fedora-infra/fedmsg_meta_fedora_infrastructure/pull/94>`_
and `that feature
<https://github.com/fedora-infra/fedmsg_meta_fedora_infrastructure/pull/98>`_.

To Do
-----

At the FAD, we decided on a schedule of sorts: we'll try to get bodhi2 into
staging before the alpha feature freeze in July, but we **won't** try to get
Bodhi2 into production until a few weeks after F21 is released (Novemeber).  I
had made some previous "predictions" that we'd see it before Flock, but I
hadn't factored in any interactions with the release process.  We shouldn't
rush it and disturb that.

Here are some things left that need doing:

- **Performance** - Some pages (notably the user profile page) take far too
  long to load.  We need to work on some optimizations 

- **Finish** the masher rewrite - The rewrite is awesome now (it has 70%+ test
  coverage.  the bodhi1 masher had 0% coverage).  It's just going to take more
  time to finish working through all the things that process is responsible
  for.

- **Long-form** templates from fedmsg.meta - We hope to remove all the email
  code from Bodhi2 and just use `Fedora Notifications (fmn)
  <https://apps.fedoraproject.org/notifications>`_ for notifications.  One
  thing missing is the ability in fmn to do "long form" templates (long emails
  with lots of information).  We have a plan to do that by adding a
  ``msg2long_form(msg, **config)`` function to ``fedmsg.meta``.  It just needs
  to get written, released, and leveraged at this point.

- **Candidates Deps** would be a cool thing to auto-populate in the new update
  form.  Currently, you type in a package and it auto-populates a checkbox list
  with all the candidate builds it could find.  It would be extra neat if it
  could also find candidate **dependencies** and add them to that list as well.

- **Karma Policy Control** - we have fine-grained karma feedback now, but it
  would be nice for maintainers to set fine-grained policy based on that
  feedback.  Right now, it looks just like Bodhi1 (we just didn't have time to
  work through this corner at the FAD).

- **Taskotron feedback** - We talked it over and `submitted a patch
  <https://phab.qadevel.cloud.fedoraproject.org/D120>`_, but there's still some
  work to be done to display taskotron results in the Bodhi2 UI.
