---
categories: fedora, fedmsg, datagrepper, datanommer, pkgwat
date: 2013/07/16 00:30:00
permalink: http://threebean.org/blog/pkgwat-history
title: Querying all package history from the command line
---

After my last post on `querying datagrepper
<http://threebean.org/blog/querying-datagrepper-example/>`_, I wrote it into
my `pkgwat <https://apps.fedoraproject.org/packages/pkgwat>`_ tool as the
second-coolest subcommand:  ``$ pkgwat history PKGNAME``::

    $ sudo yum -y install pkgwat

    $ pkgwat history firefox
    +------------+------------------------------------------------+---------------------+
    | date       | event                                          | link                |
    +------------+------------------------------------------------+---------------------+
    | 2013/07/15 | stransky commented on bodhi update firefox-22. | http://ur1.ca/enmvg |
    | 2013/07/15 | suren commented on bodhi update firefox-22.0-1 | http://ur1.ca/enmvg |
    | 2013/07/10 | stransky's firefox-21.0-1.fc17 untagged from f | http://ur1.ca/eauo1 |
    | 2013/07/10 | xhorak's firefox-21.0-4.fc19 tagged into trash | http://ur1.ca/ea995 |
    | 2013/07/10 | xhorak's firefox-21.0-4.fc18 tagged into trash | http://ur1.ca/ea995 |
    | 2013/07/05 | stransky's firefox-20.0-3.fc20 tagged into tra | http://ur1.ca/ea995 |
    | 2013/07/04 | xhorak's firefox-21.0-4.fc19 untagged from f19 | http://ur1.ca/ea9a4 |
    | 2013/07/04 | xhorak's firefox-21.0-4.fc18 untagged from f18 | http://ur1.ca/ea9a1 |
    | 2013/07/03 | stransky's firefox-20.0-4.fc20 untagged from f | http://ur1.ca/ea9ac |
    | 2013/07/02 | pbrobinson's firefox-22.0-2.fc18 tagged into f | http://ur1.ca/ea9a1 |
    | 2013/07/02 | pbrobinson's firefox-22.0-2.fc18 completed     | http://ur1.ca/enmvh |
    | 2013/07/02 | firefox-22.0-2.fc18 started building           | http://ur1.ca/enmvh |
    +------------+------------------------------------------------+---------------------+

So the next time you're hacking on something and you say to yourself: "Wat wat
wat.  What just happened?"  ``$ pkgwat history PKGNAME`` is another resource
to draw on for clarity.

You can get the full help with ``$ pkgwat help history``::

    usage: pkgwat history [-h] [-f {csv,table}] [-c COLUMN]
                          [--quote {all,minimal,none,nonnumeric}]
                          [--rows-per-page ROWS_PER_PAGE] [--start-page PAGE]
                          package

    Show the fedmsg history of a package. This command queries
    https://apps.fedoraproject.org/datagrepper/

    positional arguments:
      package

    optional arguments:
      -h, --help            show this help message and exit
      --rows-per-page ROWS_PER_PAGE
      --start-page PAGE

    output formatters:
      output formatter options

      -f {csv,table}, --format {csv,table}
                            the output format, defaults to table
      -c COLUMN, --column COLUMN
                            specify the column(s) to include, can be repeated

    CSV Formatter:
      --quote {all,minimal,none,nonnumeric}
                            when to include quotes, defaults to nonnumeric
