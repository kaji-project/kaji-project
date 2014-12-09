#!/bin/bash

# DEPS
# dpkg-sig wget 

REPO_FOLDER=$1
DISTRO=$2
CODENAME="$3"
KEYID=$4

# bash tools/repo-create.sh /tmp/repo/kaji-repo debian amakuni FAB456AA

DISTRO_FOLDER="${REPO_FOLDER}/${DISTRO}"


REPREPRO=`which reprepro`
#CREATEREPO=`which createrepo`

# Check reprepro
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
if [ "$KEYID" = "" ]
then
    echo "missing key id"
    exit 1
fi

mkdir -p ${DISTRO_FOLDER}/conf
cat << EOF >> ${DISTRO_FOLDER}conf/distributions
Origin: kaji
Label: Kaji ${DISTRO} Repository
Codename: ${CODENAME}
Architectures: amd64 i386 source
Components: main
Description: This repository contains Kaji ${DISTRO} packages
SignWith: ${KEYID}
EOF
cat << EOF > ${DISTRO_FOLDER}/conf/options
basedir ${DISTRO_FOLDER}
EOF
