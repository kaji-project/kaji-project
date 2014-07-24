#!/bin/bash

# first arg: name of the obs package
# second arg: path of the source files
function obs_push {
    # Checkout the package
    osc co ${OBS_REPO}/$1

    # Check if the OBS orig and the current orig are different
    rm -rf /tmp/${1}_OBS_ORIG && mkdir /tmp/${1}_OBS_ORIG && tar -xf ${OBS_REPO}/${1}/${1}*.orig.tar.gz -C /tmp/${1}_OBS_ORIG --force-local
    diff -r ${2}/${1}/ /tmp/${1}_OBS_ORIG/${1}/ --exclude=debian --exclude=.git*

    # Only update if the source has changed
    if [ $? -ne 0 ]
    then
        echo Source has changed, uploading to obs...

        # Remove the old files
        rm ${DIR}/${OBS_REPO}/$1/*

        # Copy the new files
        ## .deb
        cp $2/$1_*.tar.gz ${DIR}/${OBS_REPO}/$1/
        cp $2/$1_*.dsc ${DIR}/${OBS_REPO}/$1/
        cp $2/$1_*.changes ${DIR}/${OBS_REPO}/$1/
        ## .rpm
        cp -f $2/$1/*.spec ${DIR}/${OBS_REPO}/$1/
        cp -f $2/$1/debian/patches/* ${DIR}/${OBS_REPO}/$1/

        # Add the changes and commit
        osc addremove ${DIR}/${OBS_REPO}/$1/*
        osc ci ${DIR}/${OBS_REPO}/$1 -m "Updated ${1}"
    else
        echo Skipping OBS upload...
    fi
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

rm -r obs.tmp