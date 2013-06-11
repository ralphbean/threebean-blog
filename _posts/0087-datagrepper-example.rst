---
categories: fedora, fedmsg, datagrepper, datanommer
date: 2013/06/11 14:00:00
permalink: http://threebean.org/blog/querying-datagrepper-example
title: Querying fedmsg history for package details by example
---

In case you missed it, you can `query fedmsg history now
<http://threebean.org/blog/new-datagrepper-api/>`_ with the
`datagrepper API <https://apps.fedoraproject.org/datagrepper/>`_.

I wrote up an example here to show how you might use it in a script.
This will print out the whole history of the `hovercraft
<http://hovercraft.rtfd.org>`_ package (at least everything that is
published via fedmsg anyways).  In time, I hope to add it to
`python-pkgwat-api <http://pkgwat.rtfd.org>`_ and as a subcommand of the
`pkgwat <https://apps.fedoraproject.org/packages/pkgwat>`_ command line tool.
Until then, you can use::

    #!python
    #!/usr/bin/env python
    """ Query the history of a package using datagrepper!

    Check out the api at https://apps.fedoraproject.org/datagrepper/

    :Author: Ralph Bean <rbean@redhat.com>
    :License: LGPLv2+

    """

    import datetime
    import re
    import requests

    regexp = re.compile(
        r'<p class="success">Your ur1 is: '
        '<a href="(?P<shorturl>.+)">(?P=shorturl)</a></p>')


    def shorten_url(longurl):
        response = requests.post("http://ur1.ca/", data=dict(longurl=longurl))
        return regexp.search(response.text).groupdict()['shorturl']


    def get_data(package, rows=20):
        url = "https://apps.fedoraproject.org/datagrepper/raw/"
        response = requests.get(
            url,
            params=dict(
                package=package,
                delta=9999999,
                meta=['subtitle', 'link'],
                rows_per_page=rows,
                order='desc',
            ),
        )
        data = response.json()
        return data.get('raw_messages', [])


    def print_data(package, links=False):
        for message in get_data(package, 40):
            dt = datetime.datetime.fromtimestamp(message['timestamp'])
            print dt.strftime("%Y/%m/%d"),
            print message['meta']['subtitle'],
            if links:
                print shorten_url(message['meta']['link'])
            else:
                print


    if __name__ == '__main__':
        print_data(package='hovercraft', links=False)

And here's the output:

- 2013/06/10 ralph's hovercraft-1.1-3.fc18 untagged from f18-updates-pending by bodhi http://ur1.ca/ea99c
- 2013/06/10 ralph's hovercraft-1.1-3.fc18 tagged into f18-updates by bodhi http://ur1.ca/ea99e
- 2013/06/10 ralph's hovercraft-1.1-3.fc18 untagged from f18-updates-testing by bodhi http://ur1.ca/ea99f
- 2013/06/10 ralph's hovercraft-1.1-3.fc19 tagged into f19-updates-pending by bodhi http://ur1.ca/ea99x
- 2013/06/10 ralph's hovercraft-1.1-3.fc18 tagged into f18-updates-pending by bodhi http://ur1.ca/ea99c
- 2013/06/10 ralph submitted hovercraft-1.1-3.fc18 to stable http://ur1.ca/ea99y
- 2013/06/10 ralph submitted hovercraft-1.1-3.fc19 to stable http://ur1.ca/ea99z
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 untagged from f18-updates-testing-pending by bodhi http://ur1.ca/ea9a0
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 tagged into f18-updates-testing by bodhi http://ur1.ca/ea99f
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 untagged from f18-updates-candidate by bodhi http://ur1.ca/ea9a1
- 2013/05/21 ralph's hovercraft-1.1-3.fc19 untagged from f19-updates-testing-pending by bodhi http://ur1.ca/ea9a2
- 2013/05/21 ralph's hovercraft-1.1-3.fc19 tagged into f19-updates-testing by bodhi http://ur1.ca/ea9a3
- 2013/05/21 ralph's hovercraft-1.1-3.fc19 untagged from f19-updates-candidate by bodhi http://ur1.ca/ea9a4
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 tagged into f18-updates-testing-pending by bodhi http://ur1.ca/ea9a0
- 2013/05/21 ralph submitted hovercraft-1.1-3.fc18 to testing http://ur1.ca/ea99y
- 2013/05/21 ralph's hovercraft-1.1-3.fc17 failed to build http://ur1.ca/ea9a5
- 2013/05/21 hovercraft-1.1-3.fc17 started building http://ur1.ca/ea9a5
- 2013/05/21 ralph pushed to hovercraft (f17).  "Add BR on python3-manuel." http://ur1.ca/ea9a6
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 tagged into f18-updates-candidate by ralph http://ur1.ca/ea9a1
- 2013/05/21 ralph's hovercraft-1.1-3.fc18 completed http://ur1.ca/ea9a7
- 2013/05/21 hovercraft-1.1-3.fc18 started building http://ur1.ca/ea9a7
- 2013/05/21 ralph pushed to hovercraft (f18).  "Add BR on python3-manuel." http://ur1.ca/ea9a8
- 2013/05/20 ralph's hovercraft-1.1-3.fc19 tagged into f19-updates-testing-pending by bodhi http://ur1.ca/ea9a2
- 2013/05/20 ralph submitted hovercraft-1.1-3.fc19 to testing http://ur1.ca/ea99z
- 2013/05/20 ralph's hovercraft-1.1-3.fc19 tagged into f19-updates-candidate by ralph http://ur1.ca/ea9a4
- 2013/05/20 ralph's hovercraft-1.1-3.fc19 completed http://ur1.ca/ea9ab
- 2013/05/20 ralph's hovercraft-1.1-3.fc20 tagged into f20 by ralph http://ur1.ca/ea9ac
- 2013/05/20 ralph's hovercraft-1.1-3.fc20 completed http://ur1.ca/ea9ad
- 2013/05/20 hovercraft-1.1-3.fc19 started building http://ur1.ca/ea9ab
- 2013/05/20 hovercraft-1.1-3.fc20 started building http://ur1.ca/ea9ad
- 2013/05/20 ralph pushed to hovercraft (f19).  "Add BR on python3-manuel." http://ur1.ca/ea9ae
- 2013/05/20 ralph pushed to hovercraft (master).  "Add BR on python3-manuel." http://ur1.ca/ea9af
- 2013/05/20 ralph's hovercraft-1.1-2.fc19 failed to build http://ur1.ca/ea9ag
- 2013/05/20 hovercraft-1.1-2.fc19 started building http://ur1.ca/ea9ag
- 2013/05/20 ralph's hovercraft-1.1-2.fc19 failed to build http://ur1.ca/ea9ag
- 2013/05/20 hovercraft-1.1-2.fc19 started building http://ur1.ca/ea9ag
- 2013/05/20 ralph's hovercraft-1.1-2.fc19 failed to build http://ur1.ca/ea9ag
- 2013/05/20 hovercraft-1.1-2.fc19 started building http://ur1.ca/ea9ag
- 2013/05/20 ralph's hovercraft-1.1-2.fc19 failed to build http://ur1.ca/ea9ag
- 2013/05/20 hovercraft-1.1-2.fc19 started building http://ur1.ca/ea9ag
