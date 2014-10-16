#!/bin/bash

BASEDIR=$(dirname $(readlink -f "$0"))/..

# Colors
red='\e[0;31m'
green='\e[0;32m'
blue='\e[1;34m'
NC='\e[0m' # No Color

# first arg: name of the obs package
# second arg: path of the source files
function obs_push {
    echo
    echo "============================================================="
    echo "             Prepare $1"
    echo "============================================================="
    # Checkout the package
    echo -e "${blue}Checkout OBS repo${NC}"
    osc co ${OBS_REPO}/$1

    # Check if the OBS orig and the current orig are different
    rm -rf /tmp/${1}_OBS_ORIG && mkdir /tmp/${1}_OBS_ORIG && tar -xf ${OBS_REPO}/${1}/${1}*.orig.tar.gz -C /tmp/${1}_OBS_ORIG --force-local
    diff -r ${BASEDIR}/build-area/${1}/ /tmp/${1}_OBS_ORIG/${1}/ --exclude=debian --exclude=.git* --exclude=*.pyc --exclude=build --exclude=.pc --exclude=.*.swp --exclude=*.egg-info

    
    # Only update if the source has changed
    if [ $? -ne 0 ]
    then
        echo Source has changed, uploading to obs...

        # Remove the old files
        rm ${DIR}/${OBS_REPO}/$1/*

        # Copy the new files
        echo -e "${blue}Copy DEB files${NC}"
        ## .deb
        cp ../build-area/$1_*.tar.gz ${DIR}/${OBS_REPO}/$1/
        cp ../build-area/$1_*.dsc ${DIR}/${OBS_REPO}/$1/
        cp ../build-area/$1_*.changes ${DIR}/${OBS_REPO}/$1/
        ## .rpm
        echo -e "${blue}Copy RPM files${NC}"
        cp -f ../packages/$1/*.spec ${DIR}/${OBS_REPO}/$1/ || true
        cp -f ../packages/$1/debian/patches/* ${DIR}/${OBS_REPO}/$1/ || true

        # Add the changes and commit
        echo -e "${blue}SENDING to OBS${NC}"
        osc addremove ${DIR}/${OBS_REPO}/$1/* > /dev/null
        osc ci ${DIR}/${OBS_REPO}/$1 -m "Updated ${1}" > /dev/null
        if [[ $? -eq 0 ]]
        then
            echo -e "${green}sent to OBS${NC}"
        else
            echo -e "${red}ERROR: NOT sent to OBS${NC}"
        fi
    else
        echo Skipping OBS upload...
    fi
    exit 0
}

# Open Build Service repository
OBS_REPO=home:kaji-project

mkdir obs.tmp && cd obs.tmp

DIR=$(pwd)

# plugins
for package in `(cd ../packages && ls -d */ | tr -d '/')`
do
    echo "OBS: processing ${package}"
    obs_push $package "../packages/"
done

cd ..
rm -r obs.tmp
