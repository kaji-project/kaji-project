#!/bin/bash

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
KEYID="$4"
BASEDIR="$1"

mkdir -p $BASEDIR
wget -P $BASEDIR http://s3.amazonaws.com/influxdb/influxdb_0.8.7_amd64.deb
wget -P $BASEDIR http://s3.amazonaws.com/influxdb/influxdb_0.8.7_i686.deb
