#!/bin/bash

# DEPS
# dpkg-sig wget 

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
KEYID="$4"
DEBFILE="$5"

# bash repo-add-deb.sh /tmp/repo/kaji-repo debian amakuni FAB456AA ../build-area/adagios/adagios_1.6.1-1kaji0.2_all.deb

DISTRO_FOLDER="${REPO_FOLDER}/${DISTRO}"

# Check reprepro
REPREPRO=`which reprepro`
if [ "$REPREPRO" = "" ]
then
    echo "reprepro is missing"
    exit 2
fi
# Check dpkg-sig
DPKGSIG=`which dpkg-sig`
if [ "$DPKGSIG" = "" ]
then
    echo "dpkg-sig is missing"
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
if [ "$KEYID" = "" ]
then
    echo "missing GPG key id"
    exit 1
fi
if [ "$DEBFILE" = "" ]
then
    echo "missing deb file"
    exit 1
fi

# Check deb file
if [ ! -e "$DEBFILE" ]
then
    echo "Deb file ${DEBFILE} not found"
    exit 3
fi

dpkg-sig -k ${KEYID} --sign builder ${DEBFILE}
# Sign changes file ???
reprepro -Vb ${DISTRO_FOLDER}/kaji/ includedeb ${CODENAME} ${DEBFILE}

exit 0
