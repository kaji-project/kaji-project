FROM ubuntu:trusty

MAINTAINER Thibault Cohen <thibault.cohen@savoirfairelinux.com>

ENV DEBIAN_FRONTEND noninteractive

### Deps

RUN apt-get update

RUN apt-get install -y wget vim aptitude openssh-server sudo

### Create kaji user

RUN mkdir -p /home/kaji

RUN useradd -d /home/kaji -s /bin/bash kaji

RUN groupadd admin

RUN usermod -G admin kaji

RUN chown -R kaji:kaji /home/kaji

RUN echo kaji:kaji | chpasswd

### InfluxDB

RUN wget http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb

RUN dpkg -i influxdb_latest_amd64.deb

### OBS REPO

#RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/kaji-project/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/kaji.list"
#RUN wget http://download.opensuse.org/repositories/home:kaji-project/xUbuntu_14.04/Release.key
#RUN apt-key add - < Release.key

### Kaji stable repo

RUN gpg --recv-keys  --keyserver pgp.mit.edu 2320E8F8 && gpg --export --armor 2320E8F8 | apt-key add -

RUN echo 'deb http://deb.kaji-project.org/ubuntu14.04/ amakuni main' >> /etc/apt/sources.list.d/kaji.list

RUN apt-get update

### Installation

RUN apt-get install -y kaji

### Supervisor

RUN apt-get -y install supervisor

RUN echo '[supervisord]' > /etc/supervisor/conf.d/supervisor.conf
RUN echo 'nodaemon=true' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '[program:apache2]' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo 'command=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '[program:shinken]' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo 'command=/bin/bash -c "service shinken start"' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '[program:influxdb]' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo 'command=/bin/bash -c "service influxdb start"' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo '[program:ssh]' >> /etc/supervisor/conf.d/supervisor.conf
RUN echo 'command=/bin/bash -c "service ssh start"' >> /etc/supervisor/conf.d/supervisor.conf

### Finishing installation

RUN sudo bash /usr/sbin/kaji-finish-install

### Prepare to run

EXPOSE 80
EXPOSE 8083
EXPOSE 22

CMD echo ""; echo "####################"; echo "##     GO HERE" ;echo "####################"; echo ""; for i in `ip addr | grep 'inet ' | awk '{print $2}' | cut -f1  -d'/'`; do if [ "$i" != "127.0.0.1" ]; then echo "http://$i/"; fi; done ; echo "" ; echo "In few seconds you could be see your first monitored host (localhost)"; /usr/bin/supervisord > /dev/null 2>&1
#CMD ["/usr/bin/supervisord"]
