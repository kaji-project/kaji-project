#!/bin/bash

# DEPS
# createrepo

REPO_FOLDER=$1
DISTRO=$2
SIG_NAME=$3

# bash tools/repo-create-rpm.sh /srv/kaji-repo/ RHEL7 "Kaji Project"

DISTRO_FOLDER="${REPO_FOLDER}/${DISTRO}"


CREATEREPO=`which createrepo`

# Check reprepro
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

# Should be rhel/centos
if [ "$SIG_NAME" = "" ]
then
    echo "Missing signature name"
    exit 1
fi


mkdir -p "${DISTRO_FOLDER}"


${CREATEREPO} ${DISTRO_FOLDER}

if [ ! -f ~/.rpmmacros ];
then
    echo "%_signature gpg" > ~/.rpmmacros
fi

echo "%_gpg_name ${SIG_NAME}" >> ~/.rpmmacros


