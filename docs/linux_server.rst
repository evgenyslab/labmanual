.. Comment

Linux Server
=================

Overview
--------

#. OS Installation
#. OS Configuration
#. Nvidia GPU Driver Install
#. Docker Installation w/ GPU Drivers
#. Docker Image Building
#. Running Docker Image w/ GPU support
#. Remote Development with Jupiter-lab
#. Remote Development with PyCharm

OS Installation
---------------


Caveats
```````

Cannot Install Ubuntu 20.04 server without ethernet.

Trying fresh install, update, upgrade, nmcli install + config.

.. code-block:: bash

  sudo apt install network-manager
  nmcli d wifi list
  nmcli d connect MY_SSID password MY_SSID_PASSWORD

  nmcli connection edit MY_SSID
  $ > set ipv4.addresses 192.168.1.22/24
  $ > set ipv4.gateway 192.168.1.1
  $ > set ipv4.dns 8.8.8.8,8.8.4.4
  $ > save
  $ > quit

  reboot


in :code:/etc/resolv.conf: need to ensure nameserver is set to router IP, or
:code:8.8.8.8:

Resolve sleep issue on completly headless system (debugged with var/log/syslog)
->https://www.unixtutorial.org/disable-sleep-on-ubuntu-server/
check with: $ systemctl status sleep.target
disable with $ sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target



OS Configuration
----------------


.. code-block:: bash

  sudo apt-get install git-core \
      cmake \
      hwinfo \
      build-essential \
      vim \
      zsh \
      htop \
      screen \
      python3-pip \

  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

  # change the shell:
  chsh -s $(which zsh)
  # todo.. ln -s the oh my zsh folder from user to root...


Add the following to zshrc:

.. code-block:: bash

  if [[ $EUID == 0 ]]; then
          PROMPT="%B%F{red}root@$HOST%b%f $PROMPT"
  else
          PROMPT="%B%F{green}$HOST%b%f $PROMPT"
  fi

Need to install samba utilities
Mounting SMB drive...

Nvidia Driver Installation
--------------------------


Get GPU hw info:

.. code-block:: bash

  hwinfo --gfxcard --short

Get Nvidia drivers:

.. code-block:: bash

  apt search nvidia-driver
  sudo apt-get install nvidia-driver-450-server

  # confirm with:
  nvidia-smi


Docker Installation
-------------------

[TODO: add xref to docker install]

Docker GPU Configuration
------------------------


to get docker to use GPUs: [|ref_00|]

.. code-block:: bash

  # install runtime:
  curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list |\
      sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
  sudo apt-get update
  sudo apt-get install nvidia-container-runtime

  # restart docker service:
  sudo systemctl stop docker
  sudo systemctl start docker


Docker Image Build
------------------

[TODO: add docker xref]

The provided docker images (in dockerfiles dir) have minimal necessary
builds for python3-based development using pytorch and either ssh
development (with jetbrains tools), or jupyterlab.

Building:

.. code-block:: bash

    # Base nvidia-gpu container with pytoch:
    docker build -t nvidia-gpu-base -f nvidia-gpu-base .

    # Jupyterlab build:
    docker build -t nvidia-gpu-jupyter -f nvidia-gpu-jupyter .

    # Remote SSH development build:
    docker build -t nvidia-gpu-ssh -f nvidia-gpu-ssh .


Docker Image Running
--------------------

Two images can run, either jupyter, or ssh deveopment.

JUPYTER
```````

To nvidia-gpu-enabled docker container and develop remotely, firstly,
on the server-side, run the docker container and map any necessary
data folders to the container:

.. code-block:: bash

    # Emphasis on --gpus all
    docker run -d --gpus all -p 8888:8888 -v /path/to/Data:/tmp/Data --name dev-gpu nvidia-gpu-jupyter:latest


This will run a docker instance with the Jupyter Lab running in the
:code:`/tmp`
directory (at IP 0.0.0.0) and mapping docker's 8888 port to the server's
8888 port.

Once the container is running, to get the access token, on the server,
run:

.. code-block:: bash

    docker logs dev-gpu  # or the corresponding name of the container

This will print out the stdout of the container and will reveal Jupyter's
access token.

At this point, the Jupyterlab instance can be checked on the server
by using :code:`wget localhost:8888`, which will download an :code:`index.html` file in the current directory.

To access the Jupterlab on the working machine (laptop, etc), two
options are possible:

#. Open browser and navigate to :code:`<server_ip>:8888`
#. Port forward the server's :code:`8888` port to your machine's desired port with

    .. code-block:: bash

        ssh -N -f -L localhost:8888:localhost:8888 server_username@server_ip

        then open browser and navigate to :code:`localhost:8888`


Note: shutting down jupyter from the web interface will close the
container as well!

SSH-Remote Development (Jetbrains)
``````````````````````````````````

In server, run the container:

.. code-block:: bash

    docker run -d --gpus all --cap-add sys_ptrace -p127.0.0.1:2222:22 -v /home/en/Data:/tmp/Data --name dev-gpu nvidia-gpu-ssh


On local machine, port forward a local port to the server's 2222 port:

.. code-block:: bash

    ssh -N -f -L localhost:3333:localhost:2222 server_username@server_ip

Now, in pycharm, a new ssh environment can be added on :code:`localhost`
:code:`port:3333` with credentials `user:password`.


Verify Cuda
```````````

To verify cuda is running, in jupyter block or pycharm console, run one or
both of the following:

.. code-block:: bash

    # access container command:
    !nvidia-smi

    # get through torch:
    import torch
    torch.cuda.device_count()
    torch.cude.get_device_name(0)



.. |ref_00| raw:: html

   <a href="https://www.celantur.com/blog/run-cuda-in-docker-on-linux/" target="_blank">ref</a>
