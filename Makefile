clean:
	rm -f packages/*.build
	rm -f packages/*.changes
	rm -f packages/*.deb
	rm -f packages/*.tar.gz
	rm -f packages/*.tar.xz
	rm -f packages/*.dsc

deb: clean
	tools/make-source.sh

obs:
	tools/update-obs-packages.sh
