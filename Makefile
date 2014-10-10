dev_env:
	tools/prepare_dev_env.sh

clean:
	rm -rf build-area
	rm -rf obs.tmp

packages: clean
	tools/make-packages.sh

obs:
	rm -rf obs.tmp
	tools/update-obs-packages.sh
