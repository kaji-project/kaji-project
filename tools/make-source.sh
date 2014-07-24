#!/bin/bash

set -e

BUILD_PACKAGE="dpkg-buildpackage -us -uc --source-option=-Zgzip"

cd packages

for package in `ls`
do
    cd $package
    git checkout kaji
    # quilt will return 2 if the patches are already applied
    quilt push -a || true
    cd ..
    upstream_version=$(head $package/debian/changelog -n 1 | awk '{print $2}' | sed 's/^(\(.*\)-.*)$/\1/')
    tar -czf ${package}_${upstream_version}.orig.tar.gz $package --exclude=$package/debian/ --exclude=$package/.git/
    cd $package
    quilt pop -a || true
    $BUILD_PACKAGE
    lintian
    dh_clean
    cd ..
done
