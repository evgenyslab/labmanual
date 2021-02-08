.. Comment

######
Docker
######

This guide provides some background on :code:`docker`,
including example usages.

What is Docker?
***************

Docker is a software platform that provides 
OS-level virtualization-level as *containers*.

The *containers* are running instances of *images*.

*Images* define the based operating system layer required
for the container.

Docker can be seen similar to a virtual machine 
service, essentially providing a framework for 
starting, running, maintaining, stopping, and
removing OS-level applications.


Why is Docker?
**************

To provide an os-agnostic virtualization layer for applications.

With docker, creating *images* and running *containers* from
images allows developers to write applications regardless 
of the host operating system.

*How?*

The developer specifies the required os-layer in the *image* 
definition, which can be done through a *dockerfile*. Then, 
docker takes care of the all the backend required to run a
virtualization at an OS level and runs an instance of the 
*image* as a *container*.

Docker is a very useful tool for providing an OS-abstraction,
allowing developers to create images specifically for 
development environments, and deployment environments.


Mechanics
*********

*Image*

    A definition of the os, os configuration and execution 
    commands required by the developer.

    Docker hosts a repository of many base images that can 
    be used as a basis for virtualization.

    An image can be defined through a :code:`dockerfile` 
    which identifies the source os-image to use, and 
    builds on with added commands, including creation 
    of specific folders, downloading and installing packages
    and running scripts. Finally, the :code:`dockerfile` 
    ends with an application entry point.


*Container*

    A container is an instance of an *Image*. For example, 
    a :code:`base-linux` image will be stored as a docker 
    :code:`image`. Once a developer wants to create a running
    instance of the image, a *container* will be created 
    that specifies the instance of the image, along with
    any folder mapping, network interfaces, gpu-linking, etc.

Docker Workflow
***************

The general docker workflow consists of:

    #. Identify the use-case, either development, deployment
    #. Pull image, or create image from :code:`dockerfile`
    #. Instantiate image with required settings (network, folder
       mapping, etc)
    #. Do Work.

**NOTE**: creating a container will execute the docker file commands,
thus if the final command of the container exits, the container 
will stop after completion of the last command.

Example: Simple Linux
=====================

In this example, we will create a simple :code:`dockerfile` with 
a base linux image, install some packages, run the image, and then
enter the image and look around.

First, create a file called :code:`dockerfile`

.. code-block:: bash

   ## 1. Create docker file:
   touch dockerfile

Next, open the docker file and fill in the following:

.. literalinclude:: ../../../dockerfiles/base-linux

Save the file, then we can build the image using:

.. code-block:: bash

   docker build -t ubuntu/base:1.0 -f base-linux .

This command tells docker to build the :code:`base-linx` file from 
the current directory (:code:`.`), and tag it under base :code:`ubuntu` 
with tag :code:`base` and version :code:`1.0`.

Once the image is built, we can check the docker images by running:

.. code-block:: bash

   docker image ls
   # this will return:
   $ REPOSITORY     TAG     IMAGE ID    CREATED     SIZE
   $ ubuntu/base    1.0     108hjkbas   ....        ...

Herein, the image is created locally with an image ID.

Once the image is created, we can instantiate a container from it
that we can play around with:

.. code-block:: bash
 
   docker run -d --name test_container ubuntu/base:1.0 

this will create an image and run it in detached mode. 
To confirm the image is up
and running, you can do the following:

.. code-block:: bash

   # get container report:
   docker container ls
   # ^ should return all active containers
   # Get status of exited containers:
   docker ps

If everything ran correctly, :code:`docker container ls` should
show you the running container you created. If the container is
not listed, most likely it existed. To find exited containers, 
use the :code:`docker ps` command to list status of all recent
containers.

If you see your container in the :code:`ps` command, you can
check the docker logs using :code:`docker logs` to see what 
might have caused the container to exit.

**Note**, stopping and exiting containers will keep their 
names in docker's memory, therefore, if a container is stopped,
and a new container with the same name is desired, it is 
important to remove the stopped container:

.. code-block:: bash

   docker container rm container_name
   # Alternatively, use ID:
   docker container rm ID

With the linux container running, we can now enter the container
and explore it like a regular ssh remote connection. 

**NOTE** if the container runs an :code:`sshd` service natively,
then ssh can be used to enter the container. HOWERVER, not all 
container run :code:`sshd` service, therefore, docker can be used
to enter the container as command line:

.. code-block:: bash

   docker exec -it test_container bash

As this point, you will enter the container into :code:`bash` with
root access.

Here, you can run :code:`apt-get`, or use the container as any
linux OS.

To stop the container:

.. code-block:: bash

   # Stop the container:
   docker container stop test_container

   # Remove the container to avoid naming conflicts:
   docker container rm test_container

   # To remove the image:
   docker image rm ID

Tips and Tricks
---------------

When instantiating a container, you can identify which
ports to map between the container and the host, 
select the network device, and map any local folders to 
the container. 

Mapping folders provides the container access to the host
machine's folders without copying data.

Use the :code:`-p container_port:host_port` flag to map
the network ports between the host and the container.

Use the :code: `-v /path/to/local/folder:/path/to/container/folder` 
flag to map local folders to container folders.

If the Nvidia-container runtime is installed and 
the host machine has gpus available for use, the gpus can 
be attached to the container using :code:`--gpus all`.

Add the above flags to the :code:`docker run` command.

Example: Simple Python
======================

In this example, we will use a :code:`jupyter-lab` docker image.
We will pull the image using command line, instantiate it into a
container, and then use Jupyter-lab on the host machine through a
web browser.

TODO.

Supplementary References
************************

TODO

..  comment
    # TODO
    ------

    - Remote Docker development with Clion/Pycharm -> can do

    - How to attach local dir to docker container? [use -v]
    - How to run container in background? [need to have some process in foreground, then `docker run -d`]
    - How to make custom image using dockerfile? [`docker build ...`]
    - How to clone private repo in build process?
      - can give container ssh keys, use `--squash` command to squash layers during install
      - if ssh can't be used, may need to make shell script to run multi-stage build + commit output
    - How to connect to running container from multiple host terminals? [`docker exec -it container_name bash/zsh`]


    - how to delete contrains from local? [`docker container rm container_name`]

    - how to set where local containers are stored?
    - how to interface data into/out of container?
    - how to communicate between two containers on the same machine?
    - How to pipe connection from container to host (i.e. run jupyterlab in
      container and GUI in host)

    - example multi stage build with tag (private repo / no keys)
      - how to work to save files with container if its removed? what is a typical workflow?
        - can commit container to an image using `docker commit container_name ...`

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

    Install Docker on mac using provided instructions:

    https://docs.docker.com/docker-for-mac/install/

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



    References
    -----------

    [Docker](https://docs.docker.com/get-started/)
    [Docker Tutorail](https://docker-curriculum.com/)
