#!/bin/bash

# DEPS
# dpkg-sig wget 

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
DSCFILE="$4"

# bash repo-add-deb.sh /tmp/repo/kaji-repo debian amakuni ../build-area/adagios/adagios_1.6.1-1kaji0.2.dsc

DISTRO_FOLDER="${REPO_FOLDER}/${DISTRO}"

# Check reprepro
REPREPRO=`which reprepro`
if [ "$REPREPRO" = "" ]
then
    echo "reprepro is missing"
    exit 2
fi

# Check args
if [ "$REPO_FOLDER" = "" ]
then
    echo "missing repo folder"
    exit 1
fi
# Should be debian/ubuntu
if [ "$DISTRO" = "" ]
then
    echo "missing distro"
    exit 1
fi
if [ "$CODENAME" = "" ]
then
    echo "missing codename"
    exit 1
fi
if [ "$DSCFILE" = "" ]
then
    echo "missing deb file"
    exit 1
fi

# Check deb file
if [ ! -e "$DSCFILE" ]
then
    echo "DSC file ${DSCFILE} not found"
    exit 3
fi

# Sign changes file ???
reprepro -S main -P standard -b ${DISTRO_FOLDER} includedsc ${CODENAME} ${DSCFILE}

exit 0
