.. comment


#################
OS Configurations
#################

General Information HERE


Linux
=====

I've been running |xref_mint|  over the last couple of years, and have
so far preferred it to |xref_ubuntu|  distributions. I have also tried 
|xref_element| which had a nice UI, however, the inner workings of the 
networking did not fit my needs, and the UI was not comparable enough
coming from macOS.

.. |xref_mint| raw:: html

    <a href="https://linuxmint.com/" target="_blank">Linux Mint</a>

.. |xref_ubuntu| raw:: html

    <a href="https://ubuntu.com/" target="_blank">Ubuntu</a>

.. |xref_element| raw:: html

    <a href="https://elementary.io/" target="_blank">Elementary OS</a>



Installing from USB
-------------------

#. Download Image from `Linux Mint Download Page <https://linuxmint.com/edition.php?id=284">`_,

#. `Use Balena Etcher tool <https://www.balena.io/etcher/>`_ to create
   USB install media.

#. Insert USB key into target hardware, enter boot menu with one of :code:`F2 | F12 | del` keys.
   Then, during installation options, choose "something else" option when 
   prompted to erase or install beside existing OS.

#. Partition the Harddrive using the following approximate Scheme:

    - One EFI partition with 100-500mb
    - One ext4 called '/' for root OS ~ 15-30gb
    - One ext4 called '/home' for all data ~ 30+gb
    - one swap ~1-4gb

   This approach relies on placing the OS on its own partition and 
   separating the :code:`home` directory from anything that is 
   application / OS specific.


Installing Packages
-------------------

Use the following to install all dependencies and base applications on the 
fresh linux install.

.. code-block:: bash

    ## updates & upgrades:
    sudo apt-get update
    sudo apt-get upgrade

    ## create new su account:
    sudo passwd

    ## Install git:
    sudo apt-get install \
        git-core \
        cmake \
        build-essential \
        gdb \
        vim \
        openssh-client \
        sshfs \
        cifs-utils \
        zsh \
        vtop \
        screen \
        imagemagick \
        python3-pip \
        python3-virtualenv \
        python3-tk \
        libgtest-dev \
        zlib1g-dev \
        libturbojpeg \
        libssl-dev \
        libuv-dev \
        libsm6 \
        libxext6 \
        libxrender-dev

    ## Change the shell to zsh:        
    chsh -s `which zsh`

**Troubleshooting:**

    If getting a :code:`PAM permission` error, or a :code:`which zsh invalid command`
    errror, most likely culprit is that :code:`/etc/passwd` is set to:

    :code:`root:x:0:0:root:/root: which zsh` this should be changed to:
    :code:`root:x:0:0:root:/root:/usr/bin/zsh`

Log and Out for changes to take effect

Docker
^^^^^^

.. code-block:: bash

    # Install Docker
    sudo apt-get install docker docker.io
    # set permissions (make sure $USER is set correctly)
    sudo usermod -a -G docker $USER
    # reboot
    sudo reboot -h now


Latex & Doxygen
^^^^^^^^^^^^^^^

.. code-block:: bash

    ## Firstly Install Latex & dependencies:
    # cd into temp folder:
    cd ~/Downloads
    # download the TexLive file:
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    # unpack:
    tar -xvf install-tl-unx.tar.g
    cd install-tl-unx
    # call installer:
    sudo perl install-tl # not sure if sudo should be called..
    # ^^^^ TAKES A LOOOOONG TIME!
    # add to path (in bashrc or zshrc)
    export PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"
    # test with:
    latex small2e

    ## Next Install Ghostscript for file exporting:
    # install:
    sudo apt-get install ghostscript
    # test:
    gs

    ## FINALLY Install Doxygen with graph generation support
    # install using ubuntu repo:
    sudo apt-get install doxygen
    # may need to install 'dot' with:
    sudo apt-get install graphviz


Configuring Packages
--------------------

ZSH
^^^

First step is to set zsh to use :code:`Oh my zsh`:

    .. code-block:: bash

        ## Get Oh My Zsh:
        wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh


**TIP:** to remove username from bash prompt, add the following
to the bottom of `.zshrc` file:

    .. code-block:: bash

        if [[ $EUID == 0 ]]; then
            PROMPT="%B%F{red}root%b%f $PROMPT"
        else
          PROMPT="%B%F{green}user%b%f $PROMPT"
        fi


**TIP:** to link zsh from local user to superuser by linking 
:code:`$HOME/username/.oh-my-zsh` and :code:`$HOME/username/.zshrc` to
:code:`/root/.oh-my-zsh` and :code:`/root/.zshrc`:

    .. code-block:: bash

        sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
        sudo ln -s $HOME/.zshrc /root/.zshrc


GIT
^^^

Github has introduced new token and two-factor based 
authorizations for cloning.

Please follow |ref-gh-token|, or |ref-gl-token| to create
and attach tokens to your projects.

.. |ref-gh-token| raw:: html

   <a href="https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token" target="_blank">github's</a>


.. |ref-gl-token| raw:: html

   <a href="https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html" target="_blank">gitlab's</a>


To remove existing credentials stored using git's 
:code:`credential helper`, use the following:

.. code-block:: bash

   git config --global --unset credential.helper

**NOTE** On a mac system, the keychain stores git's
credentials, see |ref-mac-git|.

.. |ref-mac-git| raw:: html

   <a href="https://stackoverflow.com/questions/11067818/how-do-you-reset-the-stored-credentials-in-git-credential-osxkeychain/13421154#:~:text=Just%20go%20to%20Applications%20%2D%3E%20Utilties,password%20from%20with%20the%20app." target="_blank">here</a>

**The following is deprecated for GitHub**

.. code-block:: bash

    Use the following to enable git credential helper (
    note, this may not be supported by github in near
    future):

        .. code-block:: bash

            # setup credential helper:
            git config --global credential.helper store


GTest
^^^^^

Finalize the GTEST install by linking the compiled libraries:

    .. code-block:: bash

        cd /usr/src/gtest
        cmake CMakeLists.txt
        make
        cp *.a /usr/lib


Pyenv
^^^^^

Install :code:`pyenv` using the guide provided |xref_pyenv_conf|.

.. |xref_pyenv_conf| raw:: html

    <a href="https://github.com/pyenv/pyenv#basic-github-checkout" target="_blank">HERE</a>


Vim
^^^

To finalize VIM configuration, add :code:`Vundle` Package to VIM:

    .. code-block:: bash

        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

To setup EN's vim:

    .. code-block:: bash

        wget https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/source/codeSauces/vimrc -O ~/.vimrc

Once installed, in :code:`vim` use :code:`:PluginInstall` to install all plugins.



Hardware-Specifics
------------------

This section is meant to capture hardware specific configuraitons I've encountered.


Lenovo-Wacom Tablets
^^^^^^^^^^^^^^^^^^^^

Note that for the Lenovo X1 Thinkpad with Wacom tablet, I was able to install Linux mint natively with VM player W10 edition. To get pen input to work correctly (namely, OneNote in W10), VM needs to provide control to linux for wacom pen input AND its best to disable the touch capability of the wacom tablet:

see: |ref000|.

.. |ref000| raw:: html

        <a href="https://askubuntu.com/questions/984339/disable-wacom-finger-touch-in-ubuntu-16-04-3" target="_blank"> HERE </a>

.. code-block:: bash

        xsetwacom --list devices
        # prints out device list... there should be a touch

        # disable finger touch:
        xsetwacom --set "Wacom Intuos Pro M Finger touch" Touch off

        # confirm:
        xsetwacom --get "Wacom Intuos Pro M Finger touch" Touch off

This way, in the VM, windows (and host Linux) will only react to pen input, meaning that in OneNote you will not get the pen marking up the page from your palm.




FIND A NEW HOME
---------------


[TODO: move to development-python notes]
A note on virutal environmnets:

When copying a virutal environment, the `~/activate` script stores the absolute path to the virtual env, thus need to modify this when creating a copy!


## Useful python packages:
pip install numpy
scikit-learn
opencv-python
opencv-utils
imutils
matplotlib
moviepy

# If using ROS with opencv in Python
If ros is installed, it will most likely change all the symlinks for cv2.so. Thus, when making a new virtual env and pip install opencv-python opencv-contrib, the cv2.so file is not named correctly. Thus, when using ipython and trying to import cv2, the program will try to import the system python opencv which is Ros's installtion.

To fix this issue, do the following:
```bash
cv ~/.virtualenvs/VirtualEnvName/lib/pythonXX/site-packages/cv2/
```
here, rename the weird cv2.XXX.so to cv2.so:
```bash
mv cv2.XXX.so cv2.so
```



Linux Server
============

**ISSUES TO RESOLVE**

- [ ] docker loses containers / images on restart; seems to be known issue
- [ ] docker can't link gpu after restart, seems to be fixed with :code:`sudo systemctl docker stop` / start

The linux server installation and configuration is almost identical to 
the standard  linux mint installation, with some slight changes to 
account for lack of :code:`X` or, running headless.

The major caveat of installing a headless linux version is that 
there is not really a clean to do it without some monitor or 
visual feedback, since visual feedback is needed to verify choices and 
selctions.

I've been using the :code:`Ubuntu Server` image for headless installations.
This OS has been proven to work stabily in the environments I require.

The installation image can be found at the |xref_userver_dl|. 

.. |xref_userver_dl| raw:: html

        <a href="https://ubuntu.com/download/server#downloads" target="_blank">Ubuntu Server Download
        page</a>


To install from USB, see :ref:`OSConfigurations:Installing from USB`


Installing Packages
-------------------

.. code-block:: bash

  sudo apt-get install git-core \
      cmake \
      hwinfo \
      build-essential \
      vim \
      zsh \
      htop \
      screen \
      libbz2-dev \
      libreadline6-dev \
      libsqlite3-dev \
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

NOTES
^^^^^

I've added two extra dockerfiles with :code:`-dev-` in the middle,
one for :code:`nvidia-gpu-dev-base` and one for :code:`nvidia-gpu-dev-ssh`. These
files use the :code:`cudnn7` and development base images that should provide
access to :code:`nvcc` compiler and *nvidia* headers.

I've noticed my server machine has troubles auto-starting docker service on 
reboot, running:

.. code-block:: bash

   sudo systemctl stop docker
   sudo systemctl start docker

fixes the issue, however I will have to dig in further to identify the root cause

Docker Image Running
--------------------

Two images can run, either jupyter, or ssh deveopment.

JUPYTER
^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In server, run the container:

.. code-block:: bash

    docker run -d --gpus all --cap-add sys_ptrace -p127.0.0.1:2222:22 -v /home/en/Data:/tmp/Data --name dev-gpu nvidia-gpu-ssh


On local machine, port forward a local port to the server's 2222 port:

.. code-block:: bash

    ssh -N -f -L localhost:3333:localhost:2222 server_username@server_ip

Now, in pycharm, a new ssh environment can be added on :code:`localhost`
:code:`port:3333` with credentials `user:password`.


Verify Cuda
-----------

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

Caveats
-------

It seems like cannot Install Ubuntu 20.04 server without ethernet.

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



Tips & Tricks
-------------

Some systems have auto sleep enabled by default as a system service. 
This may not be desirable for systems that should stay awake for 
remote work.

It is possible to check :code:`/var/log/syslog` to see if :code:`sleep.taget`
is triggered after period of inactivity.

To disable the automatic sleep and hybernate services, use:

.. code-block:: bash

    # Inspect:
    systemctly status sleep.target
    # Disable: 
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

|xref_source00|

.. |xref_source00| raw:: html

    <a href="https://www.unixtutorial.org/disable-sleep-on-ubuntu-server/" target="_blank">ref</a>



macOS
=====

The macOS is built on a linux-like system, however, unlike common linux distros,
it is missing a package manager (i.e. :code:`apt`). 

*Currently testing with Big Sur*


Install Brew
------------

Thus, the first step of setting up a mac for development is the installation
of a packagement tool, namely, :code:`homebrew`, or :code:`brew`. The installation
can be found on the |xref_brew|  website.

Install Packages
----------------

Once brew is installed, the following packages can be installed:

.. code-block:: bash

   # Update Brew
   brew update

   # Install zsh --depracated, zsh native to mac
   # brew install zsh

   # Install macvim
   brew install macvim

   # Install cmake
   brew install cmake

   # Install python
   brew install python

   # Install pyenv (for python versions)
   brew install pyenv 

   # Install virtualenv for python
   brew install virtualenv

   # Install MacTex for Latex Compilation:
   brew install mactex

   # Install doxygen:
   brew install doxygen

Configure Packages
------------------

The following section provides information, guidance and some reasoning
behind various component configurations.

Pyenv
^^^^^

Pyenv post installation configuration can be found |xref_pyenv_conf|.

ZSH
^^^

The first part of configuring :code:`zsh` is to install
:code:`Oh My Zsh`: |xref_ohmyzsh_install|. 

Next step would be to set up the :code:`~/.zshrc` file. There
are many ways to configure the file, the following is an 
example of what I have appended to mine, along with some 
descriptive information for my items.

Note, I am using :code:`robbyrussell` theme.

.. rli:: https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/source/codeSauces/zshsauce
 
This can be quickly added to your :code:`~/.zshrc` using the following command:

.. code-block:: bash

    `wget https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/zshsauce -O ->> ~/.zshrc` 


VIM
^^^

Vim is a terminal editor that is very portable. My take on the configuration of vim
can be found **ADD XREF**.

To setup EN's vim:

    .. code-block:: bash

        curl -o ~/.vimrc https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/source/codeSauces/vimrc 

Supplementary Packages
----------------------

The following packages are not available through |xref_brew| at the 
moment, and thus warrant their own section.

Docker
^^^^^^

|xref_docker| is an OS-level virtualization platform for running applications.
It is useful for development and running applications of different languages
and ensures the underlying OS is configured for the application.

For more information about docker, see the page |xref_docker_lab|.
  
To install Docker for Mac, following the instructions on the |xref_docker_install| 
page.


GTest
^^^^^

GTest is a C++ test-suite developed by Google.

The installation instructions for macOS can be found |xref_gtest_install|.

The installation requires updating :code:`~/.zshrc` file.


Tips & Tricks
-------------

The following tips and tricks are accumulated over time.

:code:`MDLS` File Inspection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :code:`mdls` command can be used to retrieve meta data on 
any file, useful for scripting file renaming.


If the command returns :code:`(null)` it means spotlight search 
needs to be rebuilt on the drive using :code:`sudo mdutil -E /Drive`.


Remote Parallels
^^^^^^^^^^^^^^^^

The standard |xref_parallels| installation does not provide
command line tools and integrations, however, that does not 
mean that we cannot :code:`ssh` into a linux image that is 
installed and running.

In my image configurations, I use the default network adaptor
to expose the Parallels image to my network and allow it to
dynamically receive an IP on my local network. 

Then, I can simply install and use :code:`openssh` to 
remote log into the virtual machine.

This is also useful for remote development methods as 
described in |xref_remote_development|. 



.. comment: REFERENCES

.. |xref_brew| raw:: html

    <a href="http://brew.sh/" target="_blank">Brew</a>

.. |xref_ohmyzsh_install| raw:: html

    <a href="https://ohmyz.sh/#install" target="_blank">Oh My ZSH</a>

.. |xref_pyenv_conf| raw:: html

    <a href="https://github.com/pyenv/pyenv#basic-github-checkout" target="_blank">HERE</a>

.. |xref_vim_config| raw:: html

    <a href="https://evgenyslab.github.io/labmanual/vim.html" target="_blank">HERE</a>

.. |xref_docker_lab| raw:: html

    <a href="https://evgenyslab.github.io/labmanual/docker.html" target="_blank">Docker</a>

.. |xref_docker| raw:: html

    <a href="https://www.docker.com/resources/what-container" target="_blank">Docker</a>

.. |xref_docker_install| raw:: html

    <a href="https://www.docker.com/products/docker-desktop" target="_blank">Docker</a>

.. |xref_gtest_install| raw:: html

    <a href="" target="_blank">GTest Installation</a>

.. |xref_parallels| raw:: html

    <a href="https://www.parallels.com/" target="_blank">Parallels</a>


TIPS & TRIX
===========

The following are general tips and tricks picked up over time
that are inevitabily partitially forgotten.


Linux :code:`systemctl`
-----------------------

TODO: useage

Linux Startup Service
---------------------

TODO: how to create linux startup service

- create startup script/application
- create a :code:`.service` file, put it in :code:`etc/systemd/system/` [TODO add example from 
  other service for how it looks / breaks down]
- make the :code:`.service` file, call your script/application
- put your script/application in :code:`/etc/` directory (as part of install process,
  same with :code:`.service` file)
- in install process, run :code:`chmod +x` on the script/application
- in install process, run :code:`chmod +664` on the :code:`.service` file
  

Executibles
-----------

To make files executible, especially bash/shell scripts, change the file
access control:

.. code-block:: bash

   # Change access:
   chmod +x myfile.sh
   # Run the file:
   ./myfile.sh


SSH Port Forwarding
-------------------

SSH port forwarding enables you to tunnel traffic on a specific port
from one device to another:

.. code-block:: bash

    [TODO]
    
This is very helpful in applications wherein a headless device needs
to send information over a port to remote device with a UI, best example
of this use case is running :code:`Jupyterlab` on a remote/docker device
and porting webui to local machine. See |xref_jupyter_remote| for
more information.

.. |xref_jupyter_remote| raw:: html

    <a href="" target="_blank">HERE</a>



SCP (Copy)) Through SSH Tunnel
------------------------------

In a situation where a file needs to go from :code:`A <--> B <--> C`, 
it is desired not to double copy through :code:`B`. 

To facilitate a simpler transaction, use SSH port tunneling to copy
directly :code:`A <--> C`.

For this example, A will be receiving end (user-end) and :code:`C` will be 
remote source/destination.

#. On :code:`A`, create ssh tunnel through :code:`B` to :code:`C` using:

   .. code-block:: bash

        ssh -L 12321:hostC:22 userB@hostB

   Where :code:`12321` is a randomly selected available port, 
   :code:`hostC` is the IP address of :code:`C` that is known
   to :code:`B`, :code:`userB` is the username at :code:`B`, 
   and finally, :code:`hostB` is the IP of :code:`B`.

   Note, this will open a remote connection in the current 
   terminal to :code:`B`. 

#. On :code:`A`, then run the :code:`scp` command with a port designation:

   .. code-block:: bash

        scp -P userC@127.0.0.1:/path/to.file /local/destination

   Note, the source/destinations can be changed based on the required
   transfer direction.
   

