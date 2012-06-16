---
categories: fedora, python
date: 2012/06/15 18:00:00
permalink: http://threebean.org/blog/ship-it
title: Ship It!
---

I just got into this whole `Fedora packaging <http://bit.ly/Lsvd5n>`_ thing and
found myself annoyed by all the waiting-on-koji-to-build.  It's always the same
kind of thing::

    $ git commit -a -m 'Initial commit (#12345)'
    $ fedpkg push
    $ fedpkg build
      <wait wait wait>

    $ fedpkg switch-branch f17
    $ git merge master
    $ fedpkg push
    $ fedpkg build
      <wait wait wait>
    $ fedpkg update
      <type type type>
    $ bodhi --buildroot-override BLAH

    $ fedpkg switch-branch el6
    $ git merge master
    $ fedpkg push
    $ fedpkg build
      <wait wait wait>
    $ fedpkg update
      <type type type>
    $ bodhi --buildroot-override BLAH

    $ echo "le sigh"

I had to do this for the `whole python-tw2 stack <http://bit.ly/KA3vJ3>`_; it was
`unbearable <http://bit.ly/muOfzi>`_ I tell you!

In answer, I wrote a baby scriptlet called `ship-it <bit.ly/LqQ8Yi>`_ to smooth it over.
It uses the unbelievably re__dict__ulous `pbs
<http://github.com/amoffat/pbs>`_ python module to do the dirty work (coming
soon to a Beefy Miracle near you as `python-pbs-subprocess
<https://bugzilla.redhat.com/show_bug.cgi?id=832588>`_)::

    #!python
    #!/usr/bin/env python
    """ Script for merging, pushing, building, updating, and buildroot-overriding
    changes to a package on multiple branches.

    Run this after you have made a change, committed and built the master branch
    for your new package.
    """

    import argparse
    import textwrap

    # The pbs module is amazing.
    from pbs import git, fedpkg, bodhi, rpmspec, glob

    branches = [
        {
            'short': 'f17',
            'long': 'fc17',
        },
        {
            'short': 'el6',
            'long': 'el6',
        },
    ]


    def config():
        parser = argparse.ArgumentParser(
            description=textwrap.dedent(__doc__),
            formatter_class=argparse.RawDescriptionHelpFormatter,
        )
        parser.add_argument(
            '--user', dest='user',
            help='Your FAS username.')
        parser.add_argument(
            '--type', dest='type',
            help="Type.  (bugfix, enhancement, security)")
        parser.add_argument(
            '--bugs', dest='bugs',
            help="Specify any number of Bugzilla IDs (--bugs=1234,5678)")
        parser.add_argument(
            '--notes', dest='notes',
            help='Update notes')
        parser.add_argument(
            '--duration', dest='duration', type=int, default=7,
            help="Duration of the buildroot override in days.")
        parser.add_argument(
            '--forgive-build', dest='forgive', action='store_true', default=False,
            help="Don't stop the script if a build fails.")

        args = parser.parse_args()

        required_args = ['user', 'type', 'bugs', 'notes']
        for required in required_args:
            if not getattr(args, required):
                parser.print_usage()
                raise ValueError("%r is required." % required)

        return args


    def main():
        args = config()
        spec = glob("*.spec")[0]
        nevr = rpmspec(q=spec).split()[0].rsplit('.', 2)[0]
        print "Processing %r" % nevr
        for branch in branches:
            nevra = nevr + '.' + branch['long']
            print "Working on %r, %r" % (branch['short'], nevra)
            print git.checkout(branch['short'])

            # Merge, push, build
            git.merge("master", _fg=True)
            fedpkg.push(_fg=True)
            if args.forgive:
                try:
                    fedpkg.build(_fg=True)
                except Exception, e:
                    print str(e)
            else:
                fedpkg.build(_fg=True)

            # Submit a new update.
            kwargs = {
                '_fg': True,
                'new': True,
                'user': args.user,
                'type': args.type,
                'notes': args.notes,
            }
            bodhi(nevra, **kwargs)

            # Buildroot override
            kwargs = {
                '_fg': True,
                'user': args.user,
                'buildroot-override': nevra,
                'duration': args.duration,
                'notes': args.notes,
            }
            bodhi(**kwargs)


    if __name__ == '__main__':
        main()
