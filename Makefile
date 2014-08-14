clean:
	rm -rf build-area

packages: clean
	tools/make-packages.sh

obs:
	tools/update-obs-packages.sh
