#!/bin/bash

BASEDIR=$(dirname $(readlink -f "$0"))/..

package_name=$1

# Colors
red='\e[0;31m'
green='\e[1;32m'
lightgreen='\e[0;32m'
blue='\e[1;34m'
yellow='\e[1;33m'
NC='\e[0m' # No Color

# first arg: name of the obs package
# second arg: path of the source files
function obs_push {
    package=$1
    echo
    echo "============================================================="
    echo "             Prepare ${package}"
    echo "============================================================="
    # Checkout the package
    echo -e "${blue}Checkout OBS repo${NC}"
    cd ${BASEDIR}/obs.tmp
    osc co ${OBS_REPO}/${package}

    upload=0
    for archive_name in orig debian
    do
        # Check if the OBS orig and the current orig are different
        echo -e "${blue}Decompress OBS ${archive_name} archive${NC}"
        rm -rf /tmp/${package}_OBS_ORIG && mkdir /tmp/${package}_OBS_ORIG && tar -xf ${OBS_REPO}/${package}/${package}*.${archive_name}.tar.* -C /tmp/${package}_OBS_ORIG --force-local
        if  [ $? -ne 0 ]
        then
            upload=1
        fi
        echo -e "${blue}Decompress NEW ${archive_name} archive${NC}"
        rm -rf /tmp/${package}_NEW_BUILD && mkdir /tmp/${package}_NEW_BUILD && tar -xf ${BASEDIR}/build-area/${package}/${package}*.${archive_name}.tar.* -C /tmp/${package}_NEW_BUILD --force-local
        if  [ $? -ne 0 ]
        then
            upload=1
        fi
        echo -e "${blue}Compare ${archive_name} archives${NC}"
        diff -r /tmp/${package}_NEW_BUILD/ /tmp/${package}_OBS_ORIG/ --exclude=.git* --exclude=*.pyc --exclude=build --exclude=.pc --exclude=.*.swp --exclude=*.egg-info
        if  [ $? -ne 0 ]
        then
            upload=1
        fi
    done

    # Only update if the source has changed
    if [ $upload -ne 0 ]
    then
        echo -e "${yellow}Source has changed, uploading to obs...${NC}"

        # Remove the old files
        rm ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/*

        # Copy the new files
        echo -e "${blue}Copy DEB files${NC}"
        ## .deb
        cp ../build-area/${package}/${package}_*.orig* ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/
        cp ../build-area/${package}/${package}_*.debian* ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/
        cp ../build-area/${package}/${package}_*.dsc ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/
        cp ../build-area/${package}/${package}_*.changes ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/
        ## .rpm
        echo -e "${blue}Copy RPM files${NC}"
        cp -f ../packages/${package}/*.spec ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/ || true
        cp -f ../packages/${package}/debian/patches/* ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/ || true

        # Add the changes and commit
        echo -e "${blue}SENDING to OBS${NC}"
        osc addremove ${BASEDIR}/obs.tmp/${OBS_REPO}/${package}/* > /dev/null
        osc ci ${BASEDIR}/obs.tmp/${OBS_REPO}/${package} -m "Updated ${package}" > /dev/null
        if [[ $? -eq 0 ]]
        then
            echo -e "${green}sent to OBS${NC}"
        else
            echo -e "${red}ERROR: NOT sent to OBS${NC}"
        fi
    else
        echo -e "${lightgreen}Sources inchanged. Skipping OBS upload...${NC}"
    fi
}

# Open Build Service repository
OBS_REPO=home:kaji-project

mkdir -p ${BASEDIR}/obs.tmp && cd ${BASEDIR}/obs.tmp

if [ "$package_name" != "" ]
then
    obs_push $package_name "../packages/"
else
    # plugins
    for package_name in `(cd ../packages && ls -d */ | tr -d '/')`
    do
        echo "OBS: processing ${package_name}"
        obs_push $package_name "../packages/"
    done
fi

rm -r ${BASEDIR}/obs.tmp
