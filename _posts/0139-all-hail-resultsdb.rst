---
categories: fedora, factory2
date: 2016/11/07 15:30:00
permalink: http://threebean.org/blog/all-hail-resultsdb
title: All Hail ResultsDB
---

This post is primarily about taking some of the lessons we learned in Fedora QA
infrastructure and applying them to some internal Red Hat pipelines as well as
generalizing the pattern to other parts of Fedora's infrastructure.

ResultsDB
=========

- ResultsDB is a database for storing results.  Unsurprising!
- It is a passive system, it doesn't actively do anything.
- It has a HTTP REST interface.  You POST new results to it and GET them out.
- It was written by Josef Skladanka of Tim Flink's Fedora QA team.

It was originally written as a part of the larger Taskotron system, but we're
talking about it independently here because it's such a *gem*!

Links
-----

- Live, `production API <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/>`_ in Fedora.
- `API documentation <http://docs.resultsdb.apiary.io/>`_
- `Source code <https://bitbucket.org/fedoraqa/resultsdb>`_

What problems can we solve with it?
-----------------------------------

In formal Factory 2.0 problem statement terms, this helps us solve the
**Serialization** and **Automation** problems directly, and indirectly all of
the problems that depend on those two.

Beyond that, let's look at **fragmentation**.  The goal of the "Central CI"
project in Red Hat was to consolidate all of the fragmentation around various
CI solutions.  This was a success in terms of operational and capex costs --
instead of 100 different CI systems running on 100 different servers sitting
under 100 different desks, we have one Central CI infrastructure backed by
OpenStack serving on-demand Jenkins masters.  Win.  A side-effect of this has
been that teams can request and configure their own Jenkins masters, without
commonality in their configuration.  While teams are incentivized to move to a
common test execution tool (Jenkins), there's no common way to organize
jobs and results.  While we reduced fragmentation at one level, it remains
untouched at another.  People informally speak of this as the problem of "the
fourteen Jenkins masters" of Platform QE.

Beyond Jenkins, some Red Hat PnT DevOps tools perform tasks that are *QE-esque* but yet
are not a part of the Central CI infrastructure.  Notably, the Errata Tool
(which plays a very similar role to Fedora's Bodhi system) directly runs jobs
like covscan, rpmgrill, rpmdiff, and TPS/insanity that are unnecessarily tied
to the &quot;release checklist&quot; phase of the workflow. They could benefit
from the common infrastructure of Central CI.  (The Errata Tool developers are
*burdened* by having to think about scheduling and storing test results while
developing the *release checklist* application.  This thing is too big.)

One option could be to attempt to *corral* all of the various dev and QE groups
into getting onto the same platform and configuring their jobs the same way.
That's a possibility, but there is a high cost to achieving that level of
social coordination.

Instead, we intend to use resultsdb and a small number of messagebus hooks to
*insulate consuming services from the details of job execution.*

Getting data out of resultsdb
-----------------------------

Resultsdb, unsurprisingly, stores results.  A result must be associated with a
`testcase`, which is just a namespaced name (for example, `general.rpmlint`).  It
must also be associated with an `item`, which you can think about as the unique
name of a build artifact produced by some RCM tool: the nevra of an rpm is a
typical value for the `item` field indicating that a particular result is
associated with a particular rpm.

Generally
~~~~~~~~~

Take a look at some examples of queries to the Fedora QA production instance of taskotron, to get an idea for what this thing can store:

- A list of known testcases `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases>`_
- Information on the depcheck testcase `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck>`_
- All known results for the depcheck testcase `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck/results <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck/results?type=koji_build>`_
- Only depcheck results associated with builds `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck/results?type=koji_build <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.depcheck/results?type=koji_build>`_
- All rpmlint results associated with the python-gradunwarp-1.0.3-1.fc24 build `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.rpmlint/results?item=python-gradunwarp-1.0.3-1.fc24 <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/testcases/dist.rpmlint/results?item=python-gradunwarp-1.0.3-1.fc24>`_
- All results of any testcase associated with that same build `https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/results?item=python-gradunwarp-1.0.3-1.fc24 <https://taskotron.fedoraproject.org/resultsdb_api//api/v1.0/results?item=python-gradunwarp-1.0.3-1.fc24>`_

For the Release Checklist
~~~~~~~~~~~~~~~~~~~~~~~~~

For the **Errata Tool** problems described in the introduction, we need to:

- Set up Jenkins jobs that do exactly what the Errata Tool processes do today:
  rpmgrill, covscan, rpmdiff, TPS/Insanity.  Ondrej Hudlicky's group is working
  on this.
- We need to ingest data from the bus about those jobs, and store that in
  resultsdb.  The Factory 2.0 team will be working on that.
- We also need to write and stand up an accompanying `waiverdb` service, that
  allows overriding an immutable result in resultsdb.  We can re-use this in
  Fedora to level up the Bodhi/taskotron interaction.
- The Errata Tool needs to be modified to refer to resultsdb's stored results
  instead of its own.
- We can decommission Errata Tool's scheduling and storage of QE-esque
  activities.  Hooray!

Note that, in Fedora the `Bodhi Updates System
<https://bodhi.fedoraproject.org/>`_ already works along these lines to
gate updates on their resultsdb status.  A **subset** of testcases are declared
as *required.*  However, if a testcase is failing erroneously, a developer must
change the requirements associated with the update to get it out the door.
This is silly.  Writing and deploying something like waiverdb will make that
much more straightforward.

On expanding this pattern in Fedora
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Note also that the `fedimg <https://github.com/fedora-infra/fedimg>`_ tool, used
to upload newly composed images to AWS, currently has *no gating* in place at
all.  It uploads everything.  While talking about how we actually want to
introduce gating into its workflow, it was proposed that it should query the
*cloud-specific test executor* called
`autocloud <https://apps.fedoraproject.org/autocloud/compose>`_.  Our answer here
should be *no*.  Autocloud should store its results in resultsdb, and fedimg
should consult resultsdb to know if an image is good or not.  This insulates
fedimg's code from the details of autocloud and enables us to more flexibly
change out QE methods and tools in the future.

For Rebuild Automation
~~~~~~~~~~~~~~~~~~~~~~

For Fedora Modularity, we know we need to `build and deploy tools to automate
rebuilds <https://fedorapeople.org/groups/modularity/sprint-5-demo/sprint5demo-threebean.ogv>`_.
In order to avoid unnecessary rebuilds of Tier 2 and Tier 3 artifacts,
we'll want to first ensure that Tier 1 artifacts are &quot;good&quot;.  The
rebuild tooling we design will need to:

- **Refer to resultsdb to gather testcase results**.  It should not query test-execution systems directly for the reasons mentioned above.
- **Have configurable policy**.  Resultsdb gives us access to *all* test results.
  Do we block rebuilds if one test fails? How do we introduce new experimental
  tests while not blocking the rebuild process?  A *constrained subset* of the
  total set of testcases should be used on a per-product/per-component basis to
  define the rebuild criteria: a policy.

Putting data in resultsdb
-------------------------

- Resultsdb receives new results by way of an HTTP POST.
- In Fedora, the `Taskotron <https://taskotron.fedoraproject.org/>`_ system
  puts results directly into resultsdb.
- Internally, we'll need a level of indirection due to the social
  coordination issue described above.  Any QE process that wants to have its
  results stored in resultsdb (and therefore be considered in PnT DevOps
  rebuild and release processes) will need to publish to the unified message
  bus or the CI-bus using the “CI-Metrics” format driven by Jiri Canderle.
- The Factory 2.0 team will write, deploy and maintain a service that listens
  for those messages, formats them appropriately, and stores them in resultsdb.
