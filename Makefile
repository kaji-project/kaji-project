
SPHINXBUILD   = sphinx-build

BUILDDIR      = build-area/documentation

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) doc
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) doc

PUBID = 2320E8F8
PUBNAME = "Kaji Project <contact@kaji-project.org>"
REPOPATH = /srv/repository/kaji-repo/
CODENAME = amakuni


# Help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  doc_html           to make standalone HTML files"
	@echo "  doc_clean          to clean documentation"
	@echo "  clean              to delete all local built packages"
	@echo "  packages           to build all packages"
	@echo "  obs                to publish all local built packages on OBS"
	@echo "  docker_build       to build a docker container"
	@echo "  docker_rebuild     to force to rebuild (without cache) a docker container"
	@echo "  docker_run         to run docker container"
	@echo "  docker_interect    to enter in docker container"


# Set branches

dev_env:
	tools/prepare_dev_env.sh

# Clean build folder
clean:
	rm -rf build-area
	rm -rf obs.tmp

# Build all packages
packages: clean
	tools/make-packages.sh

# Publish all packages to OBS
obs:
	rm -rf obs.tmp
	tools/update-obs-packages.sh


# Docker

docker_build:
	sudo docker build -t kaji .

docker_rebuild:
	sudo docker build --no-cache=true -t kaji .

docker_interact:
	sudo docker run -i -t kaji bash

docker_run:
	sudo docker run -i -t kaji


# Documentation
doc_build-env:
	virtualenv env-doc
	env-doc/bin/pip install -r tools/doc_requirements.freeze

doc_html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in `pwd`/$(BUILDDIR)/html."
	@echo "You can see it with your browser: `pwd`/$(BUILDDIR)/html/index.html"

doc_clean:
	rm -rf $(BUILDDIR)/*

doc_publish: doc_clean doc_html
	#rm -rf /tmp/kaji-website
	#git clone git@github.com:kaji-project/kaji-project.github.io.git /tmp/kaji-website
	cp -r build-area/documentation/html/* /tmp/kaji-website
	cd /tmp/kaji-website && git add .
	cd /tmp/kaji-website && git commit
	cd /tmp/kaji-website && git push origin master
	@echo "The update will be avalaible here soon: http://kaji-project.github.io"

repo_create-kaji:
	tools/repo/repo-create-deb.sh $(REPOPATH) debian7 $(CODENAME) $(PUBID)
	tools/repo/repo-create-deb.sh $(REPOPATH) ubuntu14.04 $(CODENAME) $(PUBID)
	tools/repo/repo-create-deb.sh $(REPOPATH) ubuntu12.04 $(CODENAME) $(PUBID)
	tools/repo-create-rpm.sh $(REPOPATH) centos7 $(PUBNAME)
	tools/repo-create-rpm.sh $(REPOPATH) centos6 $(PUBNAME)

repo_create-plugins:
	tools/repo/repo-create-deb.sh $(REPOPATH) debian7 plugins $(PUBID)
	tools/repo/repo-create-deb.sh $(REPOPATH) ubuntu12.04 plugins $(PUBID)
	tools/repo/repo-create-deb.sh $(REPOPATH) ubuntu14.04 plugins $(PUBID)

repo_add-debs-kaji:
	tools/repo/repo-add-debs.sh $(REPOPATH) debian7 $(CODENAME) $(PUBID) /tmp/kaji-project/Debian_7.0/
	tools/repo/repo-add-debs.sh $(REPOPATH) ubuntu14.04 $(CODENAME) $(PUBID) /tmp/kaji-project/xUbuntu_14.04/

repo_add-debs-plugins:
	tools/repo/repo-add-debs.sh $(REPOPATH) debian7 plugins $(PUBID) /tmp/sfl-monitoring:/monitoring-tools/Debian_7.0/
	tools/repo/repo-add-debs.sh $(REPOPATH) ubuntu12.04 plugins $(PUBID) /tmp/sfl-monitoring:/monitoring-tools/xUbuntu_12.04/
	tools/repo/repo-add-debs.sh $(REPOPATH) ubuntu14.04 plugins $(PUBID) /tmp/sfl-monitoring:/monitoring-tools/xUbuntu_14.04/

repo_add_rpms:
	# Todo : ensure path and add plugin
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos7 /tmp/kaji-project/centos7/*.rpm
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos6 /tmp/kaji-project/centos6/*.rpm

repo_fetch-kaji:
	# Will be replaced by https://github.com/titilambert/joulupukki
	tools/repo/fetch-obs.sh /tmp kaji-project Debian_7.0
	tools/repo/fetch-obs.sh /tmp kaji-project xUbuntu_14.04

repo_fetch-plugins:
	# Will be replaced by https://github.com/titilambert/joulupukki	
	tools/repo/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" Debian_7.0
	tools/repo/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" xUbuntu_14.04
	tools/repo/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" xUbuntu_12.04

repo_fetch-influxdb:
	tools/repo/fetch-influxdb.sh /tmp

repo_add-influxdb:
	tools/repo/repo-add-deb.sh $(REPOPATH) debian7 $(CODENAME) $(PUBID) /tmp/influxdb_0.8.8_amd64.deb
	tools/repo/repo-add-deb.sh $(REPOPATH) ubuntu14.04 $(CODENAME) $(PUBID) /tmp/influxdb_0.8.8_amd64.deb
	tools/repo/repo-add-deb.sh $(REPOPATH) debian7 $(CODENAME) $(PUBID) /tmp/influxdb_0.8.8_i686.deb
	tools/repo/repo-add-deb.sh $(REPOPATH) ubuntu14.04 $(CODENAME) $(PUBID) /tmp/influxdb_0.8.8_i686.deb
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos7 /tmp/influxdb-0.8.8-1.x86_64.rpm
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos7 /tmp/influxdb_0.8.8-1.i686.rpm
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos6 /tmp/influxdb-0.8.8-1.x86_64.rpm
	tools/repo/repo-add-rpm.sh $(REPOPATH) centos6 /tmp/influxdb_0.8.8-1.i686.rpm


repo_rebuild_index:
	tools/repo/repo-rebuild-index.sh $(REPOPATH) debian7 $(CODENAME)
	tools/repo/repo-rebuild-index.sh $(REPOPATH) ubuntu14.04 $(CODENAME)
	tools/repo/repo-rebuild-index.sh $(REPOPATH) ubuntu12.04 $(CODENAME)
	tools/repo/repo-rebuild-index.sh $(REPOPATH) debian7 plugins
	tools/repo/repo-rebuild-index.sh $(REPOPATH) ubuntu14.04 plugins
	tools/repo/repo-rebuild-index.sh $(REPOPATH) ubuntu12.04 plugins
	tools/repo/repo-sign-rpms.sh $(REPOPATH) centos7
	tools/repo/repo-sign-rpms.sh $(REPOPATH) centos6
