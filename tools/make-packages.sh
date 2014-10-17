#!/bin/bash

set -e

package_name=$1

BASEDIR=$(dirname $(readlink -f "$0"))/..
PACKAGESDIR=$BASEDIR/packages
BUILD_AREA=$BASEDIR/build-area
BUILD_PACKAGE="dpkg-buildpackage -us -uc --source-option=-Zgzip"

# Colors
red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m' # No Color

cd $BASEDIR

mkdir -p $BUILD_AREA

export QUILT_PATCHES=debian/patches




function build_package {
    package=$1

    if [[ "$package" == "build-area" ]]
    then
        continue
    fi
    echo
    echo "============================================================="
    echo "             Prepare $package"
    echo "============================================================="
    #cp -r $BASEDIR/packages/$package $BUILD_AREA
    cd $PACKAGESDIR/$package
    git checkout kaji || true
    if [[ $? -ne 0 ]]
    then
        echo "DDD"
    fi
    if [[ -L "debian" ]]
    then
        # debian is a symlink to debian.upstream (for pynag and adagios)
        rm -f debian 
        mv debian.upstream debian
    fi
    # Maybe we can do only this
    git-buildpackage -tc -us -uc --git-debian-branch=kaji --git-export-dir=../../build-area/${package} > $PACKAGESDIR/../build-area/build-${package}.report 2>&1 || true
    if [[ $? -eq 0 ]]
    then
        echo -e "${green}Build OK${NC}"
    else
        echo -e "${red}Build ERROR. Please look here: $PACKAGESDIR/../build-area/build-${package}.report${NC}"
    fi

    cd $BASEDIR
}

if [ "$package_name" != "" ]
then
    build_package $package_name
else
    for package_name in `ls -1 $BASEDIR/packages`
    do
        build_package $package_name
    done
fi
