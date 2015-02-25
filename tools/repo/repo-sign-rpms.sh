#!/bin/bash

# DEPS
# rpm

REPO_FOLDER=$1
DISTRO=$2

# bash tools/repo-create-rpm.sh /srv/kaji-repo/ RHEL7 

DISTRO_FOLDER="${REPO_FOLDER}/${DISTRO}"


RPM=`which rpm`
CREATEREPO=`which createrepo`

if [ "$RPM" = "" ]
then
    echo "rpm is missing"
    exit 2
fi

if [ "$CREATEREPO" = "" ]
then
    echo "createrepo is missing"
    exit 2
fi

# Check args
if [ "$REPO_FOLDER" = "" ]
then
    echo "Missing repo folder"
    exit 1
fi
# Should be rhel/centos
if [ "$DISTRO" = "" ]
then
    echo "Missing distro"
    exit 1
fi

if [ ! -d "${DISTRO_FOLDER}"  ]
then
    echo "${DISTRO_FOLDER} : not a directory"
    exit 1
fi


${RPM} --resign ${DISTRO_FOLDER}/*.rpm

${CREATEREPO} --update ${DISTRO_FOLDER}
