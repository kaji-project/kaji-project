#!/bin/bash

BASEDIR=$(dirname $(readlink -f "$0"))/..

# adagios
cd ${BASEDIR}/packages/adagios
git remote add upstream https://github.com/opinkerfi/adagios.git
git fetch --all
# grafana
cd ${BASEDIR}/packages/grafana
git remote add upstream https://github.com/grafana/grafana.git
git fetch --all
# influxdb-python
cd ${BASEDIR}/packages/influxdb-python
git remote add upstream http://anonscm.debian.org/cgit/collab-maint/influxdb-python.git
git fetch --all
# nagvis
cd ${BASEDIR}/packages/nagvis
git remote add upstream git://anonscm.debian.org/pkg-nagios/pkg-nagvis.git
git fetch --all
# pynag
cd ${BASEDIR}/packages/pynag
git remote add upstream https://github.com/pynag/pynag.git
git fetch --all
# shinken
cd ${BASEDIR}/packages/shinken
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken.git
git fetch --all
# shinken-mod-booster-nrpe
cd ${BASEDIR}/packages/shinken-mod-booster-nrpe
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-booster-nrpe.git
git fetch --all
# shinken-mod-livestatus
cd ${BASEDIR}/packages/shinken-mod-livestatus
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-livestatus.git
git fetch --all
# shinken-mod-logstore-null
cd ${BASEDIR}/packages/shinken-mod-logstore-null
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-logstore-null.git
git fetch --all
# shinken-mod-pickle-retention-file-generic
cd ${BASEDIR}/packages/shinken-mod-pickle-retention-file-generic
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-pickle-retention-file-generic.git
git fetch --all
# shinken-mod-simple-log
cd ${BASEDIR}/packages/shinken-mod-simple-log
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-simple-log.git
git fetch --all
# shinken-mod-influxdb
cd ${BASEDIR}/packages/shinken-mod-influxdb
git remote add upstream https://alioth.debian.org/anonscm/git/pkg-shinken/shinken-mod-influxdb.git
git fetch --all
# rekishi
cd ${BASEDIR}/packages/rekishi
git remote add upstream https://github.com/savoirfairelinux/rekishi.git
git fetch --all
