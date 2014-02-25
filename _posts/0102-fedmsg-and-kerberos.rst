---
categories: fedora,kerberos,fedmsg
date: 2014/02/25 14:40:00
permalink: http://threebean.org/blog/kerberized-fedmsg
title: Kerberized fedmsg?  Probably not.
---

Last week, someone contacted me about deploying `fedmsg <http://fedmsg.com>`_
in a kerberos-enabled environment.  They wanted to know if they could re-used
their krb infrastructure to determine the authenticity of messages.  I'm
writing this blog post to help me think it through.

First, how fedmsg works
-----------------------

fedmsg doesn't encrypt its communications at all.  Messages are either *signed*
using X509 cert/key pairs and verified against against a Certificate Authority
cert or signed and verified with GPG keys.  Those keys/certs (as of now) need
to be pre-shared.

Anyone can read the bus at any point.  Anyone can write to "the bus" at any
point.  Only some messages are trusted.  Read more in the `fedmsg.crypto
<http://www.fedmsg.com/en/latest/crypto/>`_ docs.

How I think Kerberos works
--------------------------

(... but I'm probably wrong.  Have mercy on me).

Kerberos has two central servers that are used to manage trust between clients
and servers:

- The Authentication Server
- The Ticket Granting Server

When a client wants to connect to a server...

- It first contacts the Authentication Server.  The Authentication
  Server responds with *two things*:

  - A "Client <-> Ticket-Granting Server" session key that is encrypted with
    the client's secret key.
  - A "Ticket Granting" Ticket that is encrypted with the Ticket Granting
    server's secret key.

- The client then does *two things*:

  - The client decrypts the first part (the session key) which it can then use
    to contact the ticket granting server (it sends an "Authenticator"; it has
    a session with it now).
  - It sends the second part -- the encrypted Ticket Granting Ticket -- to the
    Ticket Granting server *plus* the ID of the service it ultimately wants to
    connect to.

- The Ticket Granting Server then does *two things*:

  - The Ticket Granting server decrypts the Ticket Granting Ticket (with its
    own secret key)
  - It also uses the session key to decrypt the Authenticator.

- Now the Ticket Granting Server is assured that the client is who they
  say they are.  The Ticket Granting server then does *two more things*:

  - The Ticket Granting Server sends a "Client <-> The Service It Wanted To
    Connect To" ticket back to the client which is encrypted with The Service
    It Wanted To Connect To's secret key.
  - It also sends a session key for the client <-> server session back to the
    client.

- Dutifully, the client sends this new ticket to the server with which
  it ultimately wants to be in a authenticated relationship.

- That server then decrypts all this.  It increments a timestamp and
  re-encrypts it with their new session key.  It sends this back to the client.

It looks like when you issue ``kinit`` on a machine, that completes **step 1**.
Steps 2-6 are carried out independantly by programs.

Kerberized fedmsg?
------------------

The advantage of pulling of a kerberized fedmsg would be that you wouldn't have
to set up a separate public key infrastructure just for fedmsg -- you could
re-use your kerberos infrastructure.  You wouldn't have to generate a CA cert.
You wouldn't have to generate certs for each sending service, sign them with
the CA cert, and distribute them, manage them...

Is it possible?

Any fedmsg publishing process would have to first assume that the Ticket
Granting Ticket is already set up via ``kinit``.  What happens next?  Usually
that TGT is used to request *another* ticket *specifically* for communication
between the requesting program and another *specific* service.  fedmsg doesn't
work that way...  Messages are published to anyone/everyone -- an *unspecifed*
set of recipients.  It is confusing because the client/server relationship is
all twisted.

In **step 2**, there is no "target service ID" to request.

In **step 4**, there is no "target service" with a secret key to encrypt anything for.

Even if we faked something out with a 'virtual service' with its on secret key,
to whom would the fedmsg publisher *send* the encrypted ticket in **step 5**?

The prospects don't look good for a kerberized fedmsg, but I'm open to ideas if
you have them.  Hit me up in ``#fedora-apps`` on freenode or on the
`messaging-sig
<https://lists.fedoraproject.org/mailman/listinfo/messaging-sig>`_ if you want
to talk more about it.

----

**UPDATE** - 2014-02-25, `Simo Sorce <https://ssimo.org/>`_ tells me that
``kx509`` is a thing that could be used to acquire a short-lived certificate as
long as you have a TGT.  Apparently it needs some work first, though.
