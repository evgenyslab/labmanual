.. Comment

Linux
=================

Overview
--------

- Linux Mint
- Python
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


Linux Mint Basic setup for Terminal & Python
------------------------------------------------

Download Image:
``````````````````

`Official 18.04 Image <http://releases.ubuntu.com/18.04/>`_, or, using :code:`wget`:

.. code-block:: bash

	wget http://releases.ubuntu.com/18.04/ubuntu-18.04.3-desktop-amd64.iso



Create USB Install Media
````````````````````````
`Use Balena Etcher tool <https://www.balena.io/etcher/>`_.

Installing
''''''''''

During installation, choose "something else" option when prompted to erase or install beside existing OS.

HDD Partitioning:
''''''''''''''''''''
- One EFI partition with 100-500mb
- One ext4 called '/' for root OS ~ 15-30gb
- One ext4 called '/home' for all data ~ 30+gb
- one swap ~1-4gb

HARDWARE SPECIFICS
''''''''''''''''''

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

Terminal Stuffs
``````````````````

.. code-block:: bash

	## updates & upgrades:
	sudo apt-get update
	sudo apt-get upgrade

	## create new su account:
	sudo passwd

	## Install git:
	sudo apt-get install git-core \
			cmake \
			build-essential \
			vim \
			zsh \
			htop \
			screen \
			python3-pip \
			imagemagick \
			python3-tk \
			libgtest-dev \
			zlib1g-dev \
			libturbojpeg \
			libssl-dev \
			libuv-dev \
			libsm6 \
			libxext6 \
			libxrender-dev \
			openssh-client


If getting a :code:`PAM permission` error, or a :code:`which zsh invalid command`
errror, most likely culprit is that :code:`/etc/passwd` is set to:

:code:`root:x:0:0:root:/root: which zsh` this should be changed to:
:code:`root:x:0:0:root:/root:/usr/bin/zsh`

At this point, may want to log in/out for some settings to take hold.

.. code-block:: bash

	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
	chsh -s `which zsh`

Log and Out for changes to take effect

to remove username from bash prompt, add the following
to the bottom of `.zshrc` file:

.. code-block:: bash

	alias mkvenv="virtualenv -p $(which python3) .venv"
	alias activate="source .venv/bin/activate"

	if [[ $EUID == 0 ]]; then
		PROMPT="%B%F{red}root%b%f $PROMPT"
	else
	  PROMPT="%B%F{green}user%b%f $PROMPT"
	fi


OPTIONALLY: Linking zsh from local user to superuser:\
Make symlinks from :code:`$HOME/username/.oh-my-zsh` and :code:`$HOME/username/.zshrc` to
:code:`/root/.oh-my-zsh` and :code:`/root/.zshrc`:

.. code-block:: bash

	sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
	sudo ln -s $HOME/.zshrc /root/.zshrc


Git stuff
````````````
.. code-block:: bash

	# setup credential helper:
	git config --global credential.helper store


GTest
`````
.. code-block:: bash

	cd /usr/src/gtest
	cmake CMakeLists.txt
	make
	cp *.a /usr/lib


Python tools:
````````````````
.. code-block:: bash

	# install virtualenv:
	sudo -H pip install virtualenv


Vim & Vundle
`````````````````

.. code-block:: bash

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Vundle install plugins:
'''''''''''''''''''''''''''

.. code-block:: bash

	# in vim:
	:PluginInstall



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
