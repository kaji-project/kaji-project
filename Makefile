clean:
	rm -f packages/*.build
	rm -f packages/*.changes
	rm -f packages/*.deb
	rm -f packages/*.tar.gz
	rm -f packages/*.tar.xz
	rm -f packages/*.dsc

packages: clean
	tools/make-packages.sh

obs:
	tools/update-obs-packages.sh
