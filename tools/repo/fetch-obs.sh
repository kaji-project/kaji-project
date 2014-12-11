#!/bin/bash

BASEDIR=$1
URL=$2
DISTRO=$3

mkdir -p $BASEDIR

# Will download into $BASEDIR/$DISTRO
wget -r  --no-parent -P $BASEDIR -nH  --cut-dirs=2 http://download.opensuse.org/repositories/home:/$URL/$DISTRO

find $BASEDIR/$URL/$DISTRO -name '*.html*' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.btih' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.magnet' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.md5' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.meta4' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.metalink' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.mirrorlist' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.sha1' -exec rm {} \;
find $BASEDIR/$URL/$DISTRO -name '*.sha256' -exec rm {} \;
