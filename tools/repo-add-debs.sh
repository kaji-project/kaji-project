#!/bin/bash

# DEPS
# dpkg-sig wget 

REPO_FOLDER="$1"
DISTRO="$2"
CODENAME="$3"
KEYID="$4"
DEBFOLDER="$5"

# bash repo-add-deb.sh /tmp/repo/kaji-repo debian amakuni FAB456AA /tmp/Debian_7.0

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
if [ "$DEBFOLDER" = "" ]
then
    echo "missing deb file"
    exit 1
fi

if [ ! -d "$DEBFOLDER" ]
then
    echo "Deb folder ${DEBFOLDER} not found"
    exit 3
fi


TOSIGN=""
for file in $(find $DEBFOLDER -name '*.deb'); do
    signed=`dpkg-sig -l $file |grep "^builder$"|wc -l`
    if [ $signed -eq 0 ]; then
         TOSIGN="$TOSIGN $file"
    fi
done

dpkg-sig  -k ${KEYID} --sign builder $TOSIGN

for file in $(find $DEBFOLDER -name '*.deb'); do
    reprepro -Vb ${DISTRO_FOLDER} includedeb ${CODENAME} $file
done

exit 0
