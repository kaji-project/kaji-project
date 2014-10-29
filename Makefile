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

docker_build:
	sudo docker build -t kaji .

docker_rebuild:
	sudo docker build --no-cache=true -t kaji .

docker_interact:
	sudo docker run -i -t kaji bash

docker_run:
	sudo docker run -i -t kaji
