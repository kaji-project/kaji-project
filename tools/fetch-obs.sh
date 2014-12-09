#!/bin/bash

$BASEDIR=$1
$DISTRO=$2

mkdir -p $BASEDIR

# Will download into $BASEDIR/$DISTRO
wget -r  --no-parent -P $BASEDIR -nH  --cut-dirs=3 http://download.opensuse.org/repositories/home:/kaji-project/$DISTRO

find $BASEDIR/$DISTRO -name '*.html*' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.btih' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.magnet' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.md5' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.meta4' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.metalink' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.mirrorlist' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.sha1' -exec rm {} \;
find $BASEDIR/$DISTRO -name '*.sha256' -exec rm {} \;
