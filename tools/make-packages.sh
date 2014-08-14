#!/bin/bash

set -e

BASEDIR=$(dirname $(readlink -f "$0"))/..
BUILD_AREA=$BASEDIR/build-area
BUILD_PACKAGE="dpkg-buildpackage -us -uc --source-option=-Zgzip"

cd $BASEDIR

mkdir -p $BUILD_AREA

export QUILT_PATCHES=debian/patches

for package in `ls -1 $BASEDIR/packages`
do
    echo "============================================================="
    echo "             Prepare $package"
    echo "============================================================="
    cp -r $BASEDIR/packages/$package $BUILD_AREA
    cd $BUILD_AREA/$package
    git checkout kaji
    if [[ -L "debian" ]]
    then
        # debian is a symlink to debian.upstream (for pynag and adagios)
        rm -f debian 
        mv debian.upstream debian
    fi
    # quilt will return 2 if the patches are already applied
    quilt push -a || true
    cd ..
    upstream_version=$(head $package/debian/changelog -n 1 | awk '{print $2}' | sed 's/^(\([0-9]:\)\?\(.*\)-.*)$/\2/')
    tar -czf ${package}_${upstream_version}.orig.tar.gz $package --exclude=$package/debian/ --exclude=$package/.git/ --exclude=$package/.pc/
    cd $package
    quilt pop -a || true
    $BUILD_PACKAGE
    lintian || true
    dh_clean
    cd $BASEDIR
done
