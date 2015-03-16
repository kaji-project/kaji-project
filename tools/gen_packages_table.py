#!/bin/python

import urllib
import xml.etree.ElementTree as ET
import gzip

import re

URL = "http://deb.kaji-project.org"

yum_distro = ["centos6", "centos7"]

deb_distro = ["debian7", "ubuntu12.04", "ubuntu14.04"]

package_dict = {}

for distro in yum_distro:
    full_path = "/".join((URL, distro, "repodata/primary.xml.gz"))
    primary = gzip.zlib.decompress(urllib.urlopen(full_path).read(), gzip.zlib.MAX_WBITS|32)
    root = ET.fromstring(primary)
    for package in root:
        name = package[0].text
        key = "::".join((distro, package[1].text)) #Distro::arch
        version = package[2].attrib["ver"]

        if name not in package_dict:
            package_dict[name] = {}

        package_dict[name][key] = version

# http://deb.kaji-project.org/ubuntu12.04/dists/amakuni/main/binary-amd64/Packages
for distro in deb_distro:
    for release in ["amakuni", "plugins"]:
        for arch in ["amd64", "i386"]:
             full_path = "/".join((URL, distro, "dists",
                                   release, "main", "binary-"+arch,
                                   "Packages"))
             packages_file = urllib.urlopen(full_path)
             if packages_file.code == 404:
                 print "SKIPPING %s, url: %s" % ("::".join((distro, release, arch)), full_path)
                 continue

             for line in packages_file.readlines():
                 matches = re.match("Package: (.*)$", line)
                 if matches:
                    name = matches.group(1)
                    continue

                 matches = re.match("Version: (.*)-.*$", line)
                 if matches:
                    version = matches.group(1)
                    continue

                 matches = re.match("Architecture: (.*)", line)
                 if matches:
                    parch = matches.group(1)
                    continue

                 #TODO: Source

                 if line.strip() == "":
                    key = "::".join((distro, arch, parch))

                    if name not in package_dict:
                        package_dict[name] = {}

                    package_dict[name][key] = version

for name, package in package_dict.items():
    versions = package.values()
    if len(set(versions)) > 1:
        print "Version mismatch for %s:" % name
        for key, ver in package.items():
            print "    package: %s, version: %s" % (key, ver)
        print "====" * 5 
