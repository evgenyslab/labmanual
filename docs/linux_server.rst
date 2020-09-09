.. Comment

Linux Server
=================

Overview
--------

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


Add the following to zshrc:

.. code-block:: bash

  if [[ $EUID == 0 ]]; then
          PROMPT="%B%F{red}root@$HOST%b%f $PROMPT"
  else
          PROMPT="%B%F{green}$HOST%b%f $PROMPT"
  fi


Get GPU hw info:

.. code-block:: bash

  hwinfo --gfxcard --short

Get Nvidia drivers:

.. code-block:: bash

  apt search nvidia-driver
  sudo apt-get install nvidia-driver-450-server

  # confirm with:
  nvidia-smi


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

Create Container:

.. code-block:: bash

  FROM nvidia/cuda:10.2-base-ubuntu18.04

  RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ssh \
        build-essential \
        gcc \
        g++ \
        gdb \
        git \
        clang \
        cmake \
        rsync \
        tar \
        python \
        python-pip \
        python3-pip \
    && apt-get clean

  RUN ( \
        echo 'LogLevel DEBUG2'; \
        echo 'PermitRootLogin yes'; \
        echo 'PasswordAuthentication yes'; \
        echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
      ) > /etc/ssh/sshd_dev \
      && mkdir /run/sshd

    RUN useradd -m user \
      && yes password | passwd user

    # Update pip:
    RUN pip install --upgrade pip && \
        pip3 install --upgrade pip

  RUN pip3 install numpy ipython torch torchvision

  CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_dev"]


Building & running:

.. code-block:: bash

  docker build -t en/dev_base:0.1 -f dockerfile .
  docker run -d --gpus all --name dev en/dev_base:0.1


.. |ref_00| raw:: html

   <a href="https://www.celantur.com/blog/run-cuda-in-docker-on-linux/" target="_blank">ref</a>
