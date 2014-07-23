meta
====

Kaji meta - packages management workflow

This repository is intended for developers. If you want to install
kaji and read the user documenation, you should check this:
https://kaji-project.readthedocs.org/en/latest/

## How does it work
Kaji is downstream to Debian, just like Ubuntu. The packages listed
here in packages/ contain 2 branches:
* master, which tracks the Debian package on Alioth,
* kaji, which adds our patches.

With a correct remote set up to track Alioth, it's easy to get the
last Debian version of the package, and by rebasing kaji on master
from time to time, it's easy to upgrade our Kaji packages.

Here's a well set-up configuration for the package
shinken-module-livestatus:
```
$ git remote -v
origin    git@github.com:kaji-project/shinken-module-livestatus.git (fetch)
origin    git@github.com:kaji-project/shinken-module-livestatus.git (push)
upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-livestatus.git (fetch)
upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-livestatus.git (push)
```

## Workflow: add a package
```
$ cd packages
$ git submodule add https://alioth.debian.org/anonscm/git/pkg-shinken/MY-PACKAGE.git
$ cd MY-PACKAGE
$ git remote rename origin upstream
Create repo MY-PACKAGE on GitHub
$ git remote add origin git@github.com:kaji-project/MY-PACKAGE.git
$ git push -u origin master
$ git checkout -b kaji
$ quilt push -a
Do your modifications, be sure to use quilt, commit them
$ quilt pop -a
$ export DEBFULLNAME='Your name'
$ export DEBEMAIL='yourem@il.address'
$ dch [--no-auto-nmu]
Be sure to use a correct version number and to describe your changes.
```

## TODO

* Set-up Nagvis, Debian upstream being an SVN repo.
  Solution: git mirror of the SVN repo, and submodule added.
* Find last updates about Adagios' packaging
  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=744818
* What do we do with Graphite?
