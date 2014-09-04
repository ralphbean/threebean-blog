---
categories: fedora, python
date: 2014/09/04 16:10:00
permalink: http://threebean.org/blog/fedora-photowall
title: Fedora Photowall
---

If you didn't already know it, there is a `Fedora Badge for associating a
libravatar with your Fedora account
<https://badges.fedoraproject.org/badge/mugshot>`_.

.. image:: https://badges.fedoraproject.org/pngs/mugshot.png

A fun by-product of having such a thing is that we have a list of FAS
usernames of people who have public avatars with predictable URLs.  With
that, I wrote a script that pulls down that list and assembles a "photo
wall" of a random subset.  Check it out:

.. image:: http://threebean.org/blog/static/images/montage2.png
   :width: 625px

I wrote it as a part of `another project
<https://github.com/ralphbean/oculum>`_ that I ended up junking, but the
script is neat on its own.

Perhaps we can use it as a splash image for a Fedora website someday (say, next
year's Flock site or a future iteration of FAS?).  It might make a fun desktop
wallpaper, too.

Here's the script if you'd like to re-use and modify.  You can tweak the
``dimensions`` variable to change the number of rows and columns in the output.

::

    #!python
    #!/usr/bin/env python
    """ fedora-photowall.py - Make a photo montage of Fedora contributors.

    Dependencies:
     $ sudo yum install python-sh python-beautifulsoup4 python-requests ImageMagick

    Usage:   python fedora-photowall.py
    Author:  Ralph Bean
    License: LGPLv2+

    """

    import hashlib
    import os
    import random
    import urllib

    import sh
    import bs4
    import requests

    dimensions = (12, 5)

    datadir = './data'
    avatar_dir = datadir + '/avatars'
    montage_dir = datadir + '/montage'


    def make_directories():
        try:
            os.makedirs(datadir)
        except OSError:
            pass

        try:
            os.makedirs(avatar_dir)
        except OSError:
            pass

        try:
            os.makedirs(montage_dir)
        except OSError:
            pass


    def avatars(N):
        url = 'https://badges.fedoraproject.org/badge/mugshot/full'
        response = requests.get(url)
        soup = bs4.BeautifulSoup(response.text)
        last_pane = soup.findAll(attrs={'class': 'grid-100'})[-1]
        persons = last_pane.findAll('a')

        persons = random.sample(persons, N)

        for person in persons:
            name = person.text.strip()
            openid = 'http://%s.id.fedoraproject.org/' % name
            hash = hashlib.sha256(openid).hexdigest()
            url = "https://seccdn.libravatar.org/avatar/%s" % hash
            yield (name, url)


    def make_montage(candidates):
        """ Pull down avatars to disk and stich with imagemagick """

        filenames = []
        for name, url in candidates:
            filename = os.path.join(avatar_dir, name)
            if not os.path.exists(filename):
                print "Grabbing", name, "at", url
                urllib.urlretrieve(url, filename=filename)
            else:
                print "Already have", name, "at", filename
            filenames.append(filename)

        args = filenames + [montage_dir + '/montage.png']
        sh.montage('-tile', '%ix%i' % dimensions, '-geometry', '+0+0', *args)
        print "Output in", montage_dir


    def main():
        make_directories()
        N = dimensions[0] * dimensions[1]
        candidates = avatars(N)
        make_montage(candidates)

    if __name__ == '__main__':
        main()

And another example of output:

.. image:: http://threebean.org/blog/static/images/montage4.png
   :width: 625px

Cheers!
