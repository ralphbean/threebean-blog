---
categories: fedora,fedocal,supybot,zodbot
date: 2014/04/09 11:45:00
permalink: http://threebean.org/blog/new-zodbot-command-nextmeeting
title: New zodbot command -- .nextmeeting
---

With the latest release of `supybot-fedora
<https://apps.fedoraproject.org/packages/supybot-fedora>`_ comes a `new command
<http://da.gd/2jJPL>`_::

 threebean │ .nextmeeting fedora-meeting
 zodbot    │ threebean: The next meeting in #fedora-meeting is Fedora
                        Ambassadors Latam Meeting (starting in 8 hours) 
 zodbot    │ threebean: - http://da.gd/DaqKo
 threebean │ .nextmeeting fedora-meeting-1
 zodbot    │ threebean: The next meeting in #fedora-meeting-1 is Fedora
                        Server Working Group (starting in 5 days)
 zodbot    │ threebean: - http://da.gd/QO51Z

It queries the `fedocal <https://apps.fedoraproject.org/calendar>`_ API, so if
you own a meeting make sure that your information there is up-to-date (if you
check, you'll notice that pingou and I reorganized the meetings into team-based
calendars and did away with the mega "fedora-meeting" calendar.  Check the
"location" data for your meeting.)
