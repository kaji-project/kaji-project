.. _installation:

Installation
============

Ubuntu 14.04
~~~~~~~~~~~~


You can add the repository key to apt. Keep in mind that the owner of the key may distribute updates, packages and repositories that your system will trust (more information). To add the key, run:

::

  sudo sh  -c 'gpg --recv-keys  --keyserver pgp.mit.edu  2320E8F8 && gpg --export --armor 2320E8F8 | apt-key add -'


For xUbuntu 14.04 run the following:

::

  sudo sh -c "echo 'deb http://deb.kaji-project.org/ubuntu14.04/ amakuni main' >> /etc/apt/sources.list.d/kaji.list"
  sudo apt-get update
  sudo apt-get install kaji


Debian 7.0
~~~~~~~~~~

You can add the repository key to apt. Keep in mind that the owner of the key may distribute updates, packages and repositories that your system will trust (more information). To add the key, run **as root**:

::

  gpg --recv-keys  --keyserver pgp.mit.edu  2320E8F8 && gpg --export --armor 2320E8F8 | apt-key add -



For Debian 7.0 run the following **as root**:

::


  echo 'deb http://deb.kaji-project.org/debian7/ amakuni main' >> /etc/apt/sources.list.d/kaji.list 
  apt-get update
  apt-get install kaji


CentOS
~~~~~~

*Planned*

Red Hat
~~~~~~~

*Planned*

