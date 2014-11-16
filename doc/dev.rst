=======================
How to contribute
=======================

How does it work
================

Kaji is downstream to Debian, just like Ubuntu. The packages listed
here in packages/ contain 2 branches:
* master, which tracks the Debian package on Alioth,
* kaji, which adds our patches.

With a correct remote set up to track Alioth, it's easy to get the
last Debian version of the package, and by rebasing kaji on master
from time to time, it's easy to upgrade our Kaji packages.

Here's a well set-up configuration for the package
shinken-mod-livestatus:

::

    $ git remote -v
    origin    git@github.com:kaji-project/shinken-mod-livestatus.git (fetch)
    origin    git@github.com:kaji-project/shinken-mod-livestatus.git (push)
    upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-livestatus.git (fetch)
    upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-livestatus.git (push)


Workflows
=========

Get dev environment
~~~~~~~~~~~~~~~~~~~

To get dev environment, you need to clone the keji-project repository and all submodules:

::

    $ git clone git@github.com:kaji-project/kaji-project.git --recursive
    $ cd meta
    $ ./tools/add_upstream_branches.sh
    $ make dev_env


Add a package
~~~~~~~~~~~~~

Create repo MY-PACKAGE on GitHub and on openSUSE Build Service

::

    $ git submodule add git@github.com:kaji-project/shinken-mod-influxdb.git packages/shinken-mod-influxdb
    $ cd packages/shinken-mod-influxdb
    $ git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-influxdb.git
    $ git fetch --all
    $ git reset --hard  upstream/master
    $ git push -u origin master
    $ git checkout -b kaji
    $ export QUILT_PATCHES=debian/patches
    $ quilt push -a

Do your modifications, be sure to use quilt, commit them

::

    $ quilt pop -a
    $ export DEBFULLNAME='Your name'
    $ export DEBEMAIL='yourem@il.address'
    $ dch [--no-auto-nmu]

Be sure to use a correct version number and to describe your changes.

::

    $ git push origin kaji


Then commit the submodule on the meta repository

::

    $ cd ../..
    $ git submodule add git@github.com:kaji-project/shinken-mod-influxdb.git packages/shinken-mod-influxdb
    $ git add packages/shinken-mod-influxdb
    $ git commit -m "Add shinken-mod-influxdb repo"
    $ git push origin master

Add the upstream repository in file ``tools/add_upstream_branches.sh`` like this:

::

    # shinken-mod-influxdb
    cd ${BASEDIR}/packages/shinken-mod-influxdb
    git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-influxdb.git




Get a new package (new submodule)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you already have the meta repository and you need to get a new submodule:

::

    $ git submodule update --init packages/NEWSUBMODULE


Update a package
~~~~~~~~~~~~~~~~

Sync a package (submodule) with the new upstream (debian) version.
Example with Shinken:

::

    $ cd packages/shinken
    $ git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken.git
    $ git checkout master
    $ git fetch --all
    $ git reset --hard upstream/master
    $ git push origin master
    $ git checkout kaji
    $ git merge master
    $ git push origin kaji

Then commit the submodule on the meta repository

::

    $ cd ../..
    $ git add packages/shinken
    $ git commit -m "Update Shinken repo"
    $ git push origin master
    

Build packages
~~~~~~~~~~~~~~

All packages
++++++++++++

::

    $ make packages


One specific package
++++++++++++++++++++

If you want to build only one package (ie adagios)

::

    $ tools/make-packages.sh adagios


Send packages to openSUSE Build Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


All packages
++++++++++++

::

    $ make obs

One specific package
++++++++++++++++++++

If you want to send to OBS only one package (ie adagios)

::

    $ tools/update-obs-packages.sh adagios


References
==========

* https://people.debian.org/~calvin/unofficial/
