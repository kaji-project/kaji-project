FROM ubuntu:trusty

MAINTAINER Thibault Cohen <thibault.cohen@savoirfairelinux.com>

ENV DEBIAN_FRONTEND noninteractive

### Deps

RUN apt-get update

RUN apt-get install -y wget vim apache2-utils

### OBS REPO

RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/kaji-project/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/kaji.list"

RUN wget http://download.opensuse.org/repositories/home:kaji-project/xUbuntu_14.04/Release.key

RUN apt-key add - < Release.key

RUN apt-get update


### Installation


RUN apt-get install -y  apache2 git-core libapache2-mod-wsgi nagios-plugins nagios-plugins-basic nagios-plugins-standard nagios-plugins-extra shinken-common shinken-module-mod-influxdb shinken-module-livestatus shinken-module-logstore-sqlite shinken-module-pickle-retention-file-generic shinken-module-simple-log shinken-module-booster-nrpe adagios pynag nagvis apache2-utils htop

#RUN apt-get install -y kaji
