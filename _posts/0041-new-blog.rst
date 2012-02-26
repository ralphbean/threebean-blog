---
categories: python, blogofile
date: 2012/02/14 15:00:00
permalink: http://threebean.org/blog/first-post
title: Migrating from wordpress
---
I got fed up with wordpress and have moved to the python tool `blogofile
<http://blogofile.com/>`_.  I've been intermittently tending to my old blog
over at http://threebean.wordpress.com/ and getting traffic I'm happy with.
A lot of my old tutorials on tw2 regularly get referred to by google and my
new posts get picked up by readers of planet python and occasionally by reddit.

WordPress has become unbearable:

 - I have to edit my posts in a clumsy WSIWYG editor.
 - My posts appear in planet aggregators without proper links back to my blog
   and half-truncated.
 - My control of styling and javascript is limited.
 - I can't embed github gists.

So I'm trying out `blogofile <http://blogofile.com/>`_:

 - It supports both reStructuredText and markdown out of the box.
 - My styling and layout are handled by mako templates which I use already
   elsewhere.
 - I can keep my posts in git.
 - I can host everything in one place on http://threebean.org

Along the way, I picked up this `handy hack
<http://techspot.zzzeek.org/2010/12/06/my-blogofile-hacks/>`_ from zzzeek on
getting syntax highlighting working in reST posts.

I also had to script something up with ``feedparser`` to parse my exported
WordPress blog's and reimport it to blogofile.  Here's what I wrote (It's
based heavily on `this example
<https://raw.github.com/EnigmaCurry/blogofile/master/converters/wordpress2blogofile.py>`_
from the blogofile github repo::

    #!python
    #!/usr/bin/env python
    """ WordPress (xml) -> blogofile.

    Picks up an exported WordPress.com blog in XML format and builds a blogofile
    ``_posts`` directory out of it.
    """

    import codecs
    import feedparser
    import os
    import re
    import yaml


    def get_published_posts(filename):
        """ Generator over the posts in a wordpress.com XML dump. """

        d = feedparser.parse(filename)

        for entry in d['entries']:
            if entry.get('wp_attachment_url', None):
                pass
            elif entry.get('title', None) == 'About':
                pass
            else:
                yield entry


    if __name__ == '__main__':
        #Output textile files in ./_posts
        if os.path.isdir("_posts"):
            print "There's already a _posts directory here, "\
                    "I'm not going to overwrite it."
            sys.exit(1)
        else:
            os.mkdir("_posts")

        old_prefix = "http://threebean.wordpress.com/"
        new_prefix = "http://threebean.org/blog/"
        prepend_links = True

        post_num = 1
        for post in get_published_posts('wordpress-export.xml'):
            yaml_data = {
                "title": post['title'],
                "date": post['wp_post_date'].replace('-', '/'),
                "permalink": post['link'].replace(old_prefix, new_prefix),
                "categories": ", ".join([
                    tag['term'].lower() for tag in post['tags']
                ]),
                "tags": ", ".join([
                    tag['term'].lower() for tag in post['tags']
                ]),
                }
            fn = u"{0}-{1}.html".format(
                    str(post_num).zfill(4),
                    re.sub(
                        r'[/!:?\-,\']',
                        '',
                        post['title'].strip().lower().replace(' ', '_')
                    )
            )

            content = post['content'][0]['value'].replace(u"\r\n", u"\n")

            if prepend_links:
                content = "<p>Originally posted at <a href='%s'>%s</a>.</p>" % (
                    post['link'], post['link']) + content

            print "writing " + fn
            f = codecs.open(os.path.join("_posts", fn), "w", "utf-8")
            f.write("---\n")
            f.write(
                yaml.safe_dump(
                    yaml_data,
                    default_flow_style=False,
                    allow_unicode=True
                ).decode("utf-8")
            )
            f.write("---\n")
            f.write(content)
            f.close()
            post_num += 1
