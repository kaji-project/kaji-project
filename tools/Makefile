PUBID = 2320E8F8

REPOPATH = /srv/repository/kaji-repo/

create-kaji:
	tools/repo-create.sh $(REPOPATH) debian7  amakuni $(PUBID)
	tools/repo-create.sh $(REPOPATH) ubuntu14.04  amakuni $(PUBID)

create-plugins:
	tools/repo-create.sh $(REPOPATH) debian7 plugins $(PUBID)
	tools/repo-create.sh $(REPOPATH) ubuntu12.04 plugins $(PUBID)
	tools/repo-create.sh $(REPOPATH) ubuntu14.04 plugins $(PUBID)

add-debs-kaji:
	tools/repo-add-debs.sh $(REPOPATH) debian7 amakuni $(PUBID) /tmp/Debian_7.0/
	tools/repo-add-debs.sh $(REPOPATH) ubuntu14.04 amakuni $(PUBID) /tmp/xUbuntu14.04/

add-debs-plugins:
	tools/repo-add-debs.sh $(REPOPATH) debian7 plugins $(PUBID) /tmp/monitoring-tools/Debian_7.0/
	tools/repo-add-debs.sh $(REPOPATH) ubuntu12.04 plugins $(PUBID) /tmp/monitoring-tools/xUbuntu12.04/
	tools/repo-add-debs.sh $(REPOPATH) ubuntu14.04 plugins $(PUBID) /tmp/monitoring-tools/xUbuntu14.04/

fetch-kaji:
	tools/fetch-obs.sh /tmp kaji-project Debian_7.0
	tools/fetch-obs.sh /tmp kaji-project xUbuntu14.04

fetch-plugins:
	tools/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" Debian_7.0
	tools/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" xUbuntu14.04
	tools/fetch-obs.sh /tmp "sfl-monitoring:/monitoring-tools" xUbuntu12.04


