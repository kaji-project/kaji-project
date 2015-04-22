#!/bin/python

import urllib
import xml.etree.ElementTree as ET
import gzip
import rpm

import re

from collections import namedtuple

Package = namedtuple("Package", ["version", "release", "parch", "src_ver"])


def print_rst_table(table):
    # table is matrix per line [[L1C1, L1C2], [L2C1,...] ...]
    max_list = [0] * len(table[0])  # init list with 0 for each column
    for lines in table:
        for i in xrange(0, len(lines)):
            max_list[i] = max(max_list[i], len(lines[i]))

    output = list()
    output.append([("=" * i + "") for i in max_list])
    output.append([elem + " " * (max_list[j] - len(elem)) for j, elem in enumerate(table[0])])
    output.append([("=" * i + "") for i in max_list])

    for i in xrange(1, len(table)):
        output.append([elem + " " * (max_list[j] - len(elem)) for j, elem in enumerate(table[i])])
        output.append(["\n"])

    output.append([("=" * i + "") for i in max_list])

    for lines in output:
        for value in lines:
            print value,
        print


def build_table_full(package_d):
    columns = set()
    for keys in package_d.values():
        columns.update(keys.keys())

    table = []
    columns = sorted(list(columns))
    columns.insert(0, "package-name")
    # columns.append("github")
    table.append(columns)

    for name, keys in sorted(package_d.iteritems()):
        # Package tuple generate 3 lines at once
        line1 = [name]
        line2 = [""]
        line3 = [""]
        line4 = [""]
        for column in columns[1:]:
            if column not in keys:
                line1.append("N/A")
                line2.append("")
                line3.append("")
                line4.append("")
            else:
                l1, l2, l3, l4 = package_to_line(keys[column])
                line1.append(l1)
                line2.append(l2)
                line3.append(l3)
                line4.append(l4)
        table.append(line1)
        table.append(line2)
        table.append(line3)
        table.append(line4)

    return table


def keep_bad_versions(package_d):
    for name, package in package_d.items():
        versions = package.values()
        if len(set(versions)) == 1:
            del package_d[name]


def package_to_line(package_tuple):
    lines = list()
    lines.append("version: %s" % package_tuple.version)
    lines.append("release: %s" % package_tuple.release)
    lines.append("arch: %s" % package_tuple.parch)
    lines.append("src : %s" % package_tuple.src_ver)
    return lines


def filter_package_by_name(package_d, name_filter):
    new_package_d = {}
    for name, package in package_d.items():
        if name.startswith(name_filter):
            new_package_d[name] = package_d[name]
            del package_d[name]
    return new_package_d


def print_bad_version(package_d):
    for name, package in package_d.items():
        versions = package.values()
        if len(set(versions)) > 1:
            print("Version mismatch for %s:" % name)
            for key, ver in package.items():
                print("    package: %s, version: %s" % (key, ver))
            print("====" * 5)


def main():
    url = "http://deb.kaji-project.org"

    yum_distro = ["centos6", "centos7"]

    deb_distro = ["debian7", "debian8", "ubuntu12.04", "ubuntu14.04"]

    # keys : distro::package_arch for yum
    # keys : distro::repo_arch::package_arch for deb
    package_dict = {}

    for distro in yum_distro:
        full_path = "/".join((url, distro, "repodata/primary.xml.gz"))
        primary = gzip.zlib.decompress(urllib.urlopen(full_path).read(), gzip.zlib.MAX_WBITS | 32)
        root = ET.fromstring(primary)
        found_archs = []  # Architecture found in packages : i386, x64 ...

        # Packages to duplicate into found_arch because they are all/no_arch/src
        packages_to_expand = {}
        src_to_map = {}  # Src package found, we need to put src version in the related package
        for package in root:
            name = package[0].text
            arch = package[1].text
            version = package[2].attrib["ver"]
            release = package[2].attrib["rel"]

            if name not in package_dict:
                package_dict[name] = {}

            if arch == "noarch":
                # if we already found a noarch with the same name and bigger we keep it
                if name in packages_to_expand and rpm.labelCompare(
                        ('1', packages_to_expand[name].version, packages_to_expand[name].release),
                        ('1', version, release)) == 1:
                    continue

                packages_to_expand[name] = Package(version, release, arch, None)
            elif arch == "src":
                # if we already found a src version with the same name and a bigger we keep it
                if name in src_to_map and rpm.labelCompare(
                        ('1', src_to_map[name], None),
                        ('1', version, None)) == 1:
                    continue
                src_to_map[name] = version
            else:
                found_archs.append(arch)
                key = "::".join((distro, arch))  # Distro::arch
                # if we already have a package for this name and the version is bigger, keep it.
                if key in package_dict[name] and rpm.labelCompare(
                        ('1', package_dict[name][key].version, package_dict[name][key].release),
                        ('1', version, release)) == 1:
                    continue
                package_dict[name][key] = Package(version, release, arch, None)

        # Duplicate no arch / all.
        for arch in found_archs:
            key = "::".join((distro, arch))
            for name, package in packages_to_expand.items():
                package_dict[name][key] = package

            for name, version in src_to_map.items():
                if key in package_dict[name]:
                    old_p = package_dict[name][key]
                    new_p = Package(old_p.version, old_p.release, old_p.parch, version)
                    package_dict[name][key] = new_p
                else:
                    pass
                    # print "Found source package without actual package %s" % name

    # http://deb.kaji-project.org/ubuntu12.04/dists/amakuni/main/binary-amd64/Packages
    for distro in deb_distro:
        for release in ["amakuni", "plugins"]:
            for arch in ["amd64", "i386"]:
                full_path = "/".join((url, distro, "dists",
                                      release, "main", "binary-"+arch,
                                      "Packages"))
                packages_file = urllib.urlopen(full_path)
                if packages_file.code == 404:
                    # print("SKIPPING %s, url: %s" \
                    # % ("::".join((distro, release, arch)), full_path))
                    continue

                for line in packages_file.readlines():
                    matches = re.match("Package: (.*)$", line)
                    if matches:
                        name = matches.group(1)
                        continue

                    matches = re.match("Version: (.*)-(.*)$", line)
                    if matches:
                        version = matches.group(1)
                        release = matches.group(2)
                        continue

                    matches = re.match("Architecture: (.*)", line)
                    if matches:
                        parch = matches.group(1)
                        continue

                    if line.strip() == "":
                        key = "::".join((distro, arch))

                        if name not in package_dict:
                            package_dict[name] = {}

                        package_dict[name][key] = Package(version, release, parch, None)

    shinken_d = filter_package_by_name(package_dict, "shinken")
    plugins_d = filter_package_by_name(package_dict, "monitoring-plugins")
    packs_d = filter_package_by_name(package_dict, "monitoring-packs")

    print_rst_table(build_table_full(shinken_d))
    print("\n\n")
    print_rst_table(build_table_full(plugins_d))
    print("\n\n")
    print_rst_table(build_table_full(packs_d))
    print("\n\n")
    print_rst_table(build_table_full(package_dict))
    print("\n\n")

if __name__ == "__main__":
    main()
