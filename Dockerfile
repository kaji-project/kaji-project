FROM ubuntu:trusty

MAINTAINER Thibault Cohen <thibault.cohen@savoirfairelinux.com>

ENV DEBIAN_FRONTEND noninteractive

### Deps

RUN apt-get update

RUN apt-get install -y wget vim aptitude

### OBS REPO

RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/kaji-project/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/kaji.list"

RUN wget http://download.opensuse.org/repositories/home:kaji-project/xUbuntu_14.04/Release.key

RUN apt-key add - < Release.key

RUN apt-get update


### Installation


RUN apt-get install -y  apache2 git-core libapache2-mod-wsgi nagios-plugins nagios-plugins-basic nagios-plugins-standard nagios-plugins-extra shinken-common shinken-mod-influxdb shinken-mod-livestatus shinken-mod-logstore-sqlite shinken-mod-pickle-retention-file-generic shinken-mod-simple-log shinken-mod-booster-nrpe adagios pynag nagvis apache2-utils htop

#RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d
#RUN chmod +x /usr/sbin/policy-rc.d
#RUN ln -sf /bin/true /sbin/initctl

#RUN apt-get install -y kaji
