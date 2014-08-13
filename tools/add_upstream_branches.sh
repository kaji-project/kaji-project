#!/bin/bash

BASEDIR=$(dirname $(readlink -f "$0"))/..

# nagvis
cd ${BASEDIR}/packages/nagvis
git remote add upstream git://anonscm.debian.org/pkg-nagios/pkg-nagvis.git
# shinken
cd ${BASEDIR}/packages/shinken
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken.git
# shinken-module-booster-nrpe
cd ${BASEDIR}/packages/shinken-module-booster-nrpe
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-booster-nrpe.git
# shinken-module-graphite
cd ${BASEDIR}/packages/shinken-module-graphite
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-graphite.git
# shinken-module-livestatus
cd ${BASEDIR}/packages/shinken-module-livestatus
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-livestatus.git
# shinken-module-logstore-sqlite
cd ${BASEDIR}/packages/shinken-module-logstore-sqlite
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-logstore-sqlite.git
# shinken-module-pickle-retention-file-generic
cd ${BASEDIR}/packages/shinken-module-pickle-retention-file-generic
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-pickle-retention-file-generic.git
# shinken-module-simple-log
cd ${BASEDIR}/packages/shinken-module-simple-log
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-module-simple-log.git

