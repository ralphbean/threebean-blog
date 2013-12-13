---
categories: fedora,badges,datagrepper,planet
date: 2013/12/13 13:30:00
permalink: http://threebean.org/blog/planet-spew-and-a-badge-bonanza
title: Planet Spew and a Badge Bonanza
---

Last night, we found a cronjob in Fedora Infrastructure's puppet repo that had
incorrect syntax.  It had been broken since 2009::

    "Let's fix it!"
    "Yeah!"
    "Fixing is always good."

The cronjob's job was to run tmpwatch on the Fedora Planet cache.  When
it ran for the first time since 2009, it nuked a lot of files.

- This caused the planet scraper to re-scrape a great many blog posts,
  also for the first time since 2009.
- This then caused the planet scraper to broadcast fedmsg messages
  indicating that new blog posts had been found (even though they were
  old ones).
- The badge awarder picked up these messages and awarded a wheelbarrow's
  worth of new blogging badges to almost everyone.

Take a look at the datagrepper history according to zodbot::

    threebean │ .quote BDG
       zodbot │  BDG, fedbadges +1097.35% over yesterday
       zodbot │       ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▆▆█▂▂▁▁▁  ⤆ over 24 hours
       zodbot │       ↑ 18:19 UTC 12/12           ↑ 18:19 UTC 12/13
    threebean │ .quote PLN
       zodbot │  PLN, planet +69411.11% over yesterday
       zodbot │       ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▃█▁▁▁▁▁▁▁  ⤆ over 24 hours
       zodbot │       ↑ 18:18 UTC 12/12           ↑ 18:18 UTC 12/13
    ianweller │ lol

That's a lot of planet messages.  :)  Congratulations on your new
`blogging badges
<https://badges.fedoraproject.org/badge/bloggin-it!-planet-iv>`_!
