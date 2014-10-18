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

build_docker:
	sudo docker build -t kaji .

rebuild_docker:
	sudo docker build --no-cache=true -t kaji .

interact_docker:
	sudo docker run -i -t kaji bash
