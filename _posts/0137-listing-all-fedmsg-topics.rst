---
categories: fedora, fedmsg
date: 2016/09/09 14:20:00
permalink: http://threebean.org/blog/listing-all-fedmsg-topics
title: Listing all fedmsg topics
---

Recently, over in a `pull request review
<https://pagure.io/fm-orchestrator/pull-request/62#comment-9635>`_, we found
the need to list all of the existing fedmsg topics (to see if some code we were
writing would or wouldn't stumble on any of them).

Way back when, we added a feature to datagrepper that would let you list all of
the unique topics, but it never worked and was eventually removed.

Here's the next best thing::

    #!python
    #!/usr/bin/env python
    
    from fedmsg_meta_fedora_infrastructure import (
        tests,
        doc_utilities,
    )
    from fedmsg.tests.test_meta import Unspecified
    
    classes = doc_utilities.load_classes(tests)
    classes = [cls for cls in classes if hasattr(cls.context, 'msg')]
    
    topics = []
    for cls in classes:
        if not cls.context.msg is Unspecified:
            topics.append(cls.context.msg['topic']
                          .replace('.stg.', '.prod.')
                          .replace('.dev.', '.prod.'))
    
    # Unique and sort
    topics = sorted(list(set(topics)))
    
    import pprint
    pprint.pprint(topics)

Enjoy!
