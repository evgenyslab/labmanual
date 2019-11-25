.. Comment

Docker
=================

# TODO
------

- How to attach local dir to docker container?
- How to run container in background?
- How to make custom image using dockerfile?
- How to connect to running container from multiple host terminals?

- how to work to save files with container if its removed? what is a typical workflow?
- how to delete contrains from local?
- how to set where local containers are stored?
- how to interface data into/out of container?
- how to communicate between two containers on the same machine?
- How to pipe connection from container to host (i.e. run jupyterlab in
  container and GUI in host)


Installation
---------------

Ubuntu
```````

.. code-block:: bash

	sudo apt-get install docker docker.io
	# set permissions (make sure $USER is set correctly)
	sudo usermod -a -G docker $USER


macOS
`````````

<todo>

Usage
--------

Basics
``````````

.. code-block:: bash

	### List Docker CLI commands
	docker
	docker container --help

	## Display Docker version and info
	docker --version
	docker version
	docker info

	## Pull an image
	docker pull <imagename>

	## Execute Docker image
	docker run hello-world

	## Run image with consol access:
	docker run -it <image>
	## Run + map local directory to container (allows changes in both):
	docker run -v /local/folder:/container/folder -it <image>

	## Connect to existing contrainer from separate terminal

	## List Docker images
	docker image ls

	## List Docker containers (running, all, all in quiet mode)
	docker container ls
	docker container ls --all
	docker container ls -aq

	## View all active containers:
	docker ps
	# View all containers that were run:
	docker ps -a


	## Cleanup, remove active containers:
	docker rm <ID>
	# Delete all running containers:
	docker rm $(docker ps -a -q -f status=exited)

	## Get ID:


Images Storage
--------------

Docker in ubuntu stores the images in `/var/lib/docker` which means that
the more images downloaded, the more space is used in `/var/`, however, if
the partition for root is small, it is necessary to move the location of where
images will be stored [ref](https://forums.docker.com/t/how-do-i-change-the-docker-image-installation-directory/1169):

.. code-block::

	Using a symlink is another method to change image storage.

	**Caution - These steps depend on your current `/var/lib/docker` being an actual directory (not a symlink to another location).**

	Stop docker: service docker stop. Verify no docker process is running `ps faux`

	Double check docker really isn’t running. Take a look at the current docker directory: `ls /var/lib/docker/`

	Make a backup: `tar -zcC /var/lib docker > yourPath/var_lib_docker-backup-$(date +%s).tar.gz`

	Move the `/var/lib/docker` directory to your new partition: `mv /var/lib/docker yourPath/docker`

	Make a symlink: `ln -s /mnt/pd0/docker yourPath/docker`

	Take a peek at the directory structure to make sure it looks like it did before the mv: `ls youtPath/docker/` (note the trailing slash to resolve the symlink)

	Start docker back up `service docker start`

	restart your containers


TAGS
`````

Docker tags are used to specify opetions for images:
.. code-block:: bash

	# latest ubuntu:
	docker run -it ubuntu
	# Now, run 18.04:
	docker run -it ubuntu:18.04

From dockerfile
-------------------

A docker image can be built from a docker file **in the current directory using:
.. code-block:: bash

	docker build --tag=image_name:tag .

A docker file would look like this:
.. code-block:: bash

	FROM python:3
	WORKDIR /usr/src/app
	COPY requirements.txt ./
	RUN pip install --no-cache-dir -r requirements.txt

JupyterLab
``````````````

When running a container that has jupyterlab, it is necessary to port-forward
8888:
.. code-block:: bash

	docker run --it --rm -p 8888:8888

where `--it` activates interactive shell, `--rm` removes container on exit,
and `-p` exposes all ports in range.

When using Jupyter Lab within a docker container, the command to call
jupyer should include ip and root allowance, otherwise jupyterlab will
return errors:
.. code-block:: bash

	jupyterlab --ip=0.0.0.0 --allow-root


Useful Containers
--------------------

- Machine learning (maybe for amazon, with cuda support?)
- Webdev (react / flask)
- python dev
- ROS + dev

References
-----------

[Docker](https://docs.docker.com/get-started/)
[Docker Tutorail](https://docker-curriculum.com/)
