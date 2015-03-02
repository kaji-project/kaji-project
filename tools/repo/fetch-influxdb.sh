#!/bin/bash

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
KEYID="$4"
BASEDIR="$1"

mkdir -p $BASEDIR
wget -P $BASEDIR http://get.influxdb.org/influxdb_0.8.8_amd64.deb
wget -P $BASEDIR http://get.influxdb.org/influxdb_0.8.8_i686.deb
wget -P $BASEDIR http://get.influxdb.org/influxdb-0.8.8-1.x86_64.rpm
wget -P $BASEDIR http://get.influxdb.org/influxdb-0.8.8-1.i686.rpm
