---
categories: fedora, python, fedmsg, mailman
date: 2013/05/23 23:17:00
permalink: http://threebean.org/blog/plugins-for-mailman3
title: Writing plugins for Mailman 3
---

GNU Mailman 3 (the long-awaited revamp of the widely-used, widely-despised
GNU Mailman 2) is `on the way <http://pyvideo.org/video/688/mailman-3>`_, and
Fedora's `Aurélien Bompard <http://aurelien.bompard.org/>`_ has been working
on a new frontend for it (here's a `before and after screencast
<http://threebean.org/hyperkitty-screencast.webm>`_ showing some of
it off).
I set out to write a `fedmsg <http://fedmsg.com>`_ plugin for mm3 so we
can add it to `cool visualizations
<http://ralph.fedorapeople.org/so-i-turned-the-fedmsg-data-into-a-git-log-and.webm>`_,
gather more data on non-development contributions to Fedora (which is always
hard to quantify), and to support future fedmsg use cases we haven't yet
thought of.

I searched for documentation, but didn't find anything directly on how to
write plugins.  I found `Barry's chapter in AOSA
<http://www.aosabook.org/en/mailman.html>`_ to be a really helpful guide
before diving into the mailman3 source itself.  This blog post is meant to
relay my findings:  two (of many) different ways to write plugins for
mailman3.

Adding a new Handler to the Pipeline
------------------------------------

At the end of the day, all we want to do is publish a `ØMQ
<https://zeromq.org>`_ message on a ``zmq.PUB`` socket for every
mail that makes its way through mailman.

I learned that at its core mailman is composed of two sequential
processing steps.  First, a *chain* of *rules* that make *moderation*
decisions about a message (should it be posted to the list? rejected?
discarded?).  Second, a *pipeline* of *handlers* that perform *manipulation*
operations on a message (should special text be added to the end?  headers?
should it be archived?  added to the digest?).

I came up with this template while trying to figure out how to add another
handler to that second pipeline.  It works! (but its not the approach we
ended up using.  read further!)::

    #!python
    """ An example template for setting up a custom pipeline for Mailman 3.

    Message processing in mailman 3 is split into two phases, "moderation"
    and "modification".  This pipeline is for the second phase which
    will only be invoked *after* a message has been cleared for delivery.

    In order to have this module imported and setup by mailman, our ``initialize``
    function needs to be called.  This can be accomplished with the mailman 3
    ``post_hook`` in the config file::

        [mailman]
        post_hook: mm3_custom_handler_template.initialize

    After our ``initialize`` function has been called, the
    'custom-posting-pipeline' should be available internally to mailman.
    In mailman 3, each mailing list can have its *own* pipeline; precisely
    which pipeline gets used at runtime is configured in the database --
    through postorious.

    :Author: Ralph Bean <rbean@redhat.com>

    """

    from __future__ import absolute_import, print_function, unicode_literals

    import logging

    from zope.interface import implementer
    from zope.interface.verify import verifyObject

    from mailman.config import config
    from mailman.core.i18n import _
    from mailman.core.pipelines import PostingPipeline
    from mailman.interfaces.handler import IHandler

    __all__ = [
        'CustomHandler',
        'CustomPostingPipeline',
        'initialize',
    ]

    elog = logging.getLogger("mailman.error")


    @implementer(IHandler)
    class CustomHandler:
        """ Do something.. anything with the message. """

        name = 'my-custom-handler'
        description = _('Do something.. anything with the message.')

        def process(self, mlist, msg, msgdata):
            """ See `IHandler` """
            elog.error("CUSTOM HANDLER: %r %r %r" % (mlist, msg, msgdata))


    class CustomPostingPipeline(PostingPipeline):
        """ A custom posting pipeline that adds our custom handler """

        name = 'my-custom-posting-pipeline'
        description = _('My custom posting pipeline')

        _default_handlers = PostingPipeline._default_handlers + (
            'my-custom-handler',
        )


    def initialize():
        """ Initialize our custom objects.

        This should be called as the `config.mailman.post_hook` callable
        during the third phase of initialization, *after* the other default
        pipelines have been set up.

        """

        # Initialize our handler and make it available
        handler = CustomHandler()
        verifyObject(IHandler, handler)
        assert handler.name not in config.handlers, (
            'Duplicate handler "{0}" found in {1}'.format(
                handler.name, CustomHandler))
        config.handlers[handler.name] = handler

        # Initialize our pipeline and make it available
        pipeline = CustomPostingPipeline()
        config.pipelines[pipeline.name] = pipeline

The above approach works, but it involves a lot of hacking to get mailman
to *load* our code into the pipeline.  We have to occupy the mailman
``post_hook`` and then kind-of hot-patch our pipeline into the list of
existing pipelines.

A benefit of this approach is that we could use ``postorious``
(the DB) to control *which* mailing lists included our plugin and which
didn't.  The *site* administrator can leave some decisions up to the *list*
administrators.

I ended up abandoning the above approach and instead landed on...

Adding a second Archiver
------------------------

One of the Handlers in the default pipeline is the ``to-archive`` Handler.
It has a somewhat nicer API for defining multiple destinations for archival.
One of those is typically HyperKitty (or... kittystore)... but you can
add as many as you like.

I wrote this "archiver" (and threw it up on
`github <https://github.com/fedora-infra/mailman3-fedmsg-plugin>`_,
`pypi <https://pypi.python.org/pypi/mailman3-fedmsg-plugin>`_, and
`fedora <https://bugzilla.redhat.com/show_bug.cgi?id=966732>`_).
Barring tweaks and modifications, I think its the approach we'll end
up using down the road::

    #!python
    """ Publish notifications about mails to the fedmsg bus.

    Enable this by adding the following to your mailman.cfg file::

        [archiver.fedmsg]
        # The class implementing the IArchiver interface.
        class: mailman3_fedmsg_plugin.Archiver
        enable: yes

    You can exclude certain lists from fedmsg publication by
    adding them to a 'mailman.excluded_lists' list in /etc/fedmsg.d/::

        config = {
            'mailman.excluded_lists': ['bugzilla', 'commits'],
        }

    """

    from zope.interface import implements
    from mailman.interfaces.archiver import IArchiver

    import socket
    import fedmsg
    import fedmsg.config


    class Archiver(object):
        """ A mailman 3 archiver that forwards messages to the fedmsg bus. """

        implements(IArchiver)
        name = "fedmsg"

        # This is a list of the headers we're interested in publishing.
        keys = [
            "archived-at",
            "delivered-to",
            "from",
            "cc",
            "to",
            "in-reply-to",
            "message-id",
            "subject",
            "x-message-id-hash",
            "references",
            "x-mailman-rule-hits",
            "x-mailman-rule-misses",
        ]

        def __init__(self):
            """ Just initialize fedmsg. """
            hostname = socket.gethostname()
            if not getattr(getattr(fedmsg, '__local', None), '__context', None):
                fedmsg.init(name="mailman.%s" % hostname)
            self.config = fedmsg.config.load_config()


        def archive_message(self, mlist, msg):
            """Send the message to the "archiver".

            In our case, we just publish it to the fedmsg bus.

            :param mlist: The IMailingList object.
            :param msg: The message object.
            """

            if mlist.list_name in self.config.get('mailman.excluded_lists', []):
                return

            format = lambda value: value and unicode(value)
            msg_metadata = dict([(k, format(msg.get(k))) for k in self.keys])
            lst_metadata = dict(list_name=mlist.list_name)

            fedmsg.publish(topic='receive', modname='mailman',
                           msg=dict(msg=msg_metadata, mlist=lst_metadata))

        def list_url(self, mlist):
            """ This doesn't make sense for fedmsg.
            But we must implement for IArchiver.
            """
            return None

        def permalink(self, mlist, msg):
            """ This doesn't make sense for fedmsg.
            But we must implement for IArchiver.
            """
            return None
