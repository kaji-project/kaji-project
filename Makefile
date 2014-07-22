clean:
	rm -f packages/*.build
	rm -f packages/*.changes
	rm -f packages/*.deb
	rm -f packages/*.tar.gz
	rm -f packages/*.tar.xz

deb: clean
	tools/make-source.sh
