#!/bin/bash

# DEPS
# dpkg-sig wget 

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
PACKAGE="$4"

# bash repo-remove-deb.sh /tmp/repo/kaji-repo debian amakuni adagios

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
if [ "$PACKAGE" = "" ]
then
    echo "missing package name"
    exit 1
fi

reprepro -Vb ${DISTRO_FOLDER}/kaji/ remove ${CODENAME} ${PACKAGE}


exit 0
