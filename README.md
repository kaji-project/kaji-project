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
