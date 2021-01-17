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




- pip (sudo apt-get install python-pip)
- virtual envs (sudo -H pip install virtualenv)
- tk (for matplot lib support) (sudo apt-get install python3-tk)
- imagemagick (for PIL)
- openssh
- ptp4l
- cfis
- ssfs
- zsh + oh my zsh
- jetbrains
- vim
- atom
- git/cmake/gdb (build essentials)
- ssh


Installing from USB
-------------------

#. Download Image from `Official 18.04 Image <http://releases.ubuntu.com/18.04/>`_,
   or, using :code:`wget`:

    .. code-block:: bash

        wget http://releases.ubuntu.com/18.04/ubuntu-18.04.3-desktop-amd64.iso

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
------------------

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
        vim \
        openssh-client \
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

Once installed, in :code:`vim` use :code:`:PluginInstall` to install all plugins.

[TODO: xref to vim guide]


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



macOS
=====
