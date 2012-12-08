---
categories: fedora, fedmsg, identi.ca, twitter
date: 2012/12/08 12:00:00
permalink: http://threebean.org/blog/fedmsg-on-identica
title: Fedmsg Stream Now Available on identi.ca
---

I just finished setting up a fedmsg bot to post updates to `identi.ca
<https://identi.ca>`_.  You can check it out at `@fedmsgbot
<https://identi.ca/fedmsgbot/>`_.  There's also this little `realtime interface
<http://identi.ca/fedmsgbot?realtime=1>`_.

Why would this be of any interest?

 - You can check `@fedmsgbot <https://identi.ca/fedmsgbot/>`_ for a public
   timeline of the development of Fedora.
 - If you do something, and you're proud of it, you can go and "favorite" or
   "re-tweet" a message.

The code works just as well with Twitter (the bot can tweet to multiple
platforms and accounts) but I ran into the daily maximum tweet limit;
Twitter's 1000-new-updates-per-day is not enough for fedmsg.  I asked Twitter if
they'd allow an exception, but was denied.  Ah, well.. if you have any
workaround ideas, let me know.

The source for this, of course, is in the `fedmsg repo
<https://github.com/ralphbean/fedmsg/blob/develop/fedmsg/commands/tweet.py>`_.
