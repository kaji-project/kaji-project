.. _installation:

Installation
============

Ubuntu 14.04
~~~~~~~~~~~~

For xUbuntu 14.04 run the following:

::

  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/kaji-project/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/kaji.list"
  sudo apt-get update
  sudo apt-get install kaji

You can add the repository key to apt. Keep in mind that the owner of the key may distribute updates, packages and repositories that your system will trust (more information). To add the key, run:

::

  wget http://download.opensuse.org/repositories/home:kaji-project/xUbuntu_14.04/Release.key
  sudo apt-key add - < Release.key  



Debian 7.0
~~~~~~~~~~

For Debian 7.0 run the following as root:

::

  echo 'deb http://download.opensuse.org/repositories/home:/kaji-project/Debian_7.0/ /' >> /etc/apt/sources.list.d/kaji.list 
  apt-get update
  apt-get install kaji

You can add the repository key to apt. Keep in mind that the owner of the key may distribute updates, packages and repositories that your system will trust (more information). To add the key, run:

::

  wget http://download.opensuse.org/repositories/home:kaji-project/Debian_7.0/Release.key
  apt-key add - < Release.key  


CentOS
~~~~~~

*Planned*

Red Hat
~~~~~~~

*Planned*

