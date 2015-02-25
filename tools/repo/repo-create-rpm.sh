#!/bin/bash

# DEPS
# createrepo

REPO_FOLDER=$1
DISTRO=$2
SIG_NAME=$3

# bash tools/repo-create-rpm.sh /srv/kaji-repo/ RHEL7 Kaji-Porject

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

if [ ! -d "${DISTRO_FOLDER}"  ]
then
    echo "${DISTRO_FOLDER} not a directory, I won't create an empty repo"
    exit 1
fi


${CREATEREPO} ${DISTRO_FOLDER}

if [ ! -f ~/.rpmmacros ];
then
    echo "%_signature gpg" > ~/.rpmmacros
fi

echo "%_gpg_name ${SIG_NAME}" >> ~/.rpmmacros


