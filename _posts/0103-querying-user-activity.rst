---
categories: fedora,fedmsg,datagrepper
date: 2014/03/24 10:50:00
permalink: http://threebean.org/blog/querying-user-activity
title: Querying user activity
---

In July, I wrote about `some tools you can use to query Fedora package history
<http://threebean.org/blog/pkgwat-history/>`_.  This post is just to point out
that you can use the same approach to query **user** history.  (It is the same
data source that we use in `Fedora Badges <https://badges.fedoraproject.org>`_
queries -- it also comes with a `nice HTML output
<https://apps.fedoraproject.org/datagrepper/raw?user=ralph>`_).  Here's some
example output from the console::

    ~❯ ./userwat ralph
    2014-03-24T00:15:30 bodhi.update.request.stable ralph submitted datagrepper-0.4.0-2.el6 to stable https://admin.fedoraproject.org/updates/datagrepper-0.4.0-2.el6
    2014-03-24T00:15:28 bodhi.update.request.stable ralph submitted python-fedbadges-0.4.1-1.el6 to stable https://admin.fedoraproject.org/updates/python-fedbadges-0.4.1-1.el6
    2014-03-24T00:15:28 bodhi.update.request.stable ralph submitted python-taskw-0.8.1-1.el6 to stable https://admin.fedoraproject.org/updates/python-taskw-0.8.1-1.el6
    2014-03-24T00:15:27 bodhi.update.request.stable ralph submitted python-tahrir-api-0.6.0-2.el6 to stable https://admin.fedoraproject.org/updates/python-tahrir-api-0.6.0-2.el6
    2014-03-24T00:15:27 bodhi.update.request.stable ralph submitted python-fedbadges-0.4.0-1.el6 to stable https://admin.fedoraproject.org/updates/python-fedbadges-0.4.0-1.el6
    2014-03-23T13:51:16 trac.ticket.update ralph updated a ticket on the fedora-badges trac instance https://fedorahosted.org/fedora-badges/ticket/122
    2014-03-21T17:08:21 ansible.playbook.complete ralph's packages.yml playbook run completed None
    2014-03-21T17:03:38 ansible.playbook.start ralph started an ansible run of packages.yml None
    2014-03-21T16:31:48 trac.ticket.update ralph updated a ticket on the fedora-badges trac instance https://fedorahosted.org/fedora-badges/ticket/213
    2014-03-21T15:09:10 buildsys.tag ralph's python-bugzilla2fedmsg-0.1.3-1.el6 tagged into dist-6E-epel-testing by bodhi http://koji.fedoraproject.org/koji/taginfo?tagID=137

The tool isn't packaged at all, but here's the script if you'd like to copy and
use it::

    #!python
    #!/usr/bin/env python
    """ userwat - A script to query a user's history from fedmsg.
    Author: Ralph Bean
    License: LGPLv2+
    """

    import datetime
    import requests
    import sys

    format_date = lambda stamp: datetime.datetime.fromtimestamp(stamp).isoformat()


    def make_request(user, page):
        response = requests.get(
            "https://apps.fedoraproject.org/datagrepper/raw",
            params=dict(
                meta=["subtitle", "link", "title"],
                start=1,
                user=[user],
                rows_per_page=100,
                page=page,
            )
        )

        return response.json()


    def main(user):
        results = make_request(user, page=1)

        for i in range(results['pages']):
            page = i + 1
            results = make_request(user, page=page)

            for msg in results['raw_messages']:
                print format_date(msg['timestamp']),
                print msg['meta']['title'],
                print msg['meta']['subtitle'],
                print msg['meta']['link']

    if __name__ == '__main__':
        if len(sys.argv) != 2:
            print sys.argv
            print "Usage:  userwat <FAS_USERNAME>"
            sys.exit(1)

        username = sys.argv[1]
        main(username)
