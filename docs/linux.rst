.. Comment

Linux
=================

Setup
-----

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

	# updates & upgrades:
	sudo apt-get update
	sudo apt-get upgrade

	## create new su account:
	sudo passwd

	## Install git:
	sudo apt-get install git-core
	sudo apt-get install cmake build-essential

	## install oh-my-zsh:
	sudo apt-get install zsh
	# change shell to zsh:
	chsh -s $(which zsh)

	# install utilities
	sudo apt install htop screen


If getting a :code:`PAM permission` error, or a :code:`which zsh invalid command`
errror, most likely culprit is that :code:`/etc/passwd` is set to:

:code:`root:x:0:0:root:/root: which zsh` this should be changed to:
:code:`root:x:0:0:root:/root:/usr/bin/zsh`

At this point, may want to log in/out for some settings to take hold.

.. code-block:: bash

	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
	chsh -s `which zsh`

Log and Out for changes to take effect

.. code-block:: bash

	# Change zsh theme to agnoster:
	# open zshrc:
	nano ~/.zshrc
	# Change line:
	ZSH_THEME="russlebobby"
	# to:
	ZSH_THEME="agnoster"


to remove username from bash prompt, add the following
to the bottom of `.zshrc` file:

.. code-block:: bash

	alias mkvenv="virtualenv -p $(which python3) .venv"
	alias activate="source .venv/bin/activate"

	if [[ $EUID == 0 ]]; then
		PROMPT="%B%F{red}root%b%f $PROMPT"
	fi




To install fonts theme to support built-in powerline:

.. code-block:: bash

	git clone https://github.com/powerline/fonts.git --depth=1
	cd fonts
	./install.sh
	cd ..
	rm -rf fonts

set font to Droid Sans Mono Power


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
	sudo apt-get install libgnome-keyring-dev
	sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring
	git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring


Python tools:
````````````````
.. code-block:: bash

	sudo apt-get install python3-pip

	# Alias pip3 (if necessary): [This may need to be added to zshrc]
	alias pip=$(which pip3)

	# install virtualenv:
	sudo -H pip install virtualenv

  # install imagemagick for Pillow backend in Mint:
  sudo apt-get install imagemagick

  $ install python3-tk for matplot lib
  sudo apt-get install python3-tk


Aliases
``````````

Best to define aliases in `~/.zshrc`


Install vim:
```````````````

.. code-block:: bash

	sudo apt-get update
	sudo apt-get install vim

install vundle
`````````````````

.. code-block:: bash

	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Add the following to ~/.vimrc:
''''''''''''''''''''''''''''''''''

.. code-block:: bash

	set nocompatible              " be iMproved, required
	filetype off                  " required

	" set the runtime path to include Vundle and initialize
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	" alternatively, pass a path where Vundle should install plugins
	"call vundle#begin('~/some/path/here')

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	" The following are examples of different formats supported.
	" Keep Plugin commands between vundle#begin/end.
	" plugin on GitHub repo
	Plugin 'scrooloose/nerdtree.git'
	" plugin from http://vim-scripts.org/vim/scripts.html
	" Plugin 'L9'
	" Git plugin not hosted on GitHub
	" Plugin 'git://git.wincent.com/command-t.git'
	" git repos on your local machine (i.e. when working on your own plugin)
	" Plugin 'file:///home/gmarik/path/to/plugin'
	" The sparkup vim script is in a subdirectory of this repo called vim.
	" Pass the path to set the runtimepath properly.
	" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
	" Install L9 and avoid a Naming conflict if you've already installed a
	" different version somewhere else.
	" Plugin 'ascenator/L9', {'name': 'newL9'}

	" Plugin you complete me:
	Plugin 'Valloric/YouCompleteMe'

	" All of your Plugins must be added before the following line
	call vundle#end()            " required
	filetype plugin indent on    " required
	" To ignore plugin indent changes, instead use:
	"filetype plugin on
	"
	" Brief help
	" :PluginList       - lists configured plugins
	" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
	" :PluginSearch foo - searches for foo; append `!` to refresh local cache
	" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
	"
	" see :h vundle for more details or wiki for FAQ
	" Put your non-Plugin stuff after this line
	" Powerline stuff: [NOTE: NEED TO MAKE SURE THIS IS CORRECT PLACE!]
	set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim
	set t_Co=256
	set expandtab
	set shiftwidth=2
	set softtabstop=2
	set laststatus=2
	set statusline+='%f'
	" Set line numbers:
	set nu
	" You Complete Me:
	let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

Vundle install plugins:
'''''''''''''''''''''''''''

.. code-block:: bash

	# in vim:
	:PluginInstall

vim you complete me:
''''''''''''''''''''''''
.. code-block:: bash

	sudo apt-get install build-essential cmake
	sudo apt-get install python-dev python3-dev
	cd ~/.vim/bundle/YouCompleteMe
	./install.py --clang-completer

setting config file in :code:`~/.vimrc`:
........................................

.. code-block:: bash

	let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

create conf file:
......................

.. code-block::bash

	touch ~/.vim/.ycm_extra_conf.py

make conf file `this <https://github.com/Valloric/ycmd/blob/master/cpp/ycm/.ycm_extra_conf.py>`_:
.................................................................................................

.. code-block:: bash

	# This file is NOT licensed under the GPLv3, which is the license for the rest
	# of YouCompleteMe.
	#
	# Here's the license text for this file:
	#
	# This is free and unencumbered software released into the public domain.
	#
	# Anyone is free to copy, modify, publish, use, compile, sell, or
	# distribute this software, either in source code form or as a compiled
	# binary, for any purpose, commercial or non-commercial, and by any
	# means.
	#
	# In jurisdictions that recognize copyright laws, the author or authors
	# of this software dedicate any and all copyright interest in the
	# software to the public domain. We make this dedication for the benefit
	# of the public at large and to the detriment of our heirs and
	# successors. We intend this dedication to be an overt act of
	# relinquishment in perpetuity of all present and future rights to this
	# software under copyright law.
	#
	# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
	# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
	# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	# OTHER DEALINGS IN THE SOFTWARE.
	#
	# For more information, please refer to <http://unlicense.org/>

	from distutils.sysconfig import get_python_inc
	import platform
	import os
	import ycm_core

	# These are the compilation flags that will be used in case there's no
	# compilation database set (by default, one is not set).
	# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
	flags = [
	'-Wall',
	'-Wextra',
	'-Werror',
	'-Wno-long-long',
	'-Wno-variadic-macros',
	'-fexceptions',
	'-DNDEBUG',
	# You 100% do NOT need -DUSE_CLANG_COMPLETER and/or -DYCM_EXPORT in your flags;
	# only the YCM source code needs it.
	'-DUSE_CLANG_COMPLETER',
	'-DYCM_EXPORT=',
	# THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
	# use when compiling headers. So it will guess. Badly. So C++ headers will be
	# compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
	# For a C project, you would set this to 'c' instead of 'c++'.
	'-x',
	'c++',
	'-isystem',
	'../BoostParts',
	'-isystem',
	get_python_inc(),
	'-isystem',
	'../llvm/include',
	'-isystem',
	'../llvm/tools/clang/include',
	'-I',
	'.',
	'-I',
	'./ClangCompleter',
	'-isystem',
	'./tests/gmock/gtest',
	'-isystem',
	'./tests/gmock/gtest/include',
	'-isystem',
	'./tests/gmock',
	'-isystem',
	'./tests/gmock/include',
	'-isystem',
	'./benchmarks/benchmark/include',
	]

	# Clang automatically sets the '-std=' flag to 'c++14' for MSVC 2015 or later,
	# which is required for compiling the standard library, and to 'c++11' for older
	# versions.
	if platform.system() != 'Windows':
		flags.append( '-std=c++11' )


	# Set this to the absolute path to the folder (NOT the file!) containing the
	# compile_commands.json file to use that instead of 'flags'. See here for
	# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
	#
	# You can get CMake to generate this file for you by adding:
	#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
	# to your CMakeLists.txt file.
	#
	# Most projects will NOT need to set this to anything; you can just change the
	# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
	compilation_database_folder = ''

	if os.path.exists( compilation_database_folder ):
		database = ycm_core.CompilationDatabase( compilation_database_folder )
	else:
		database = None

	SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

	def DirectoryOfThisScript():
		return os.path.dirname( os.path.abspath( __file__ ) )


	def IsHeaderFile( filename ):
		extension = os.path.splitext( filename )[ 1 ]
		return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


	def GetCompilationInfoForFile( filename ):
	# The compilation_commands.json file generated by CMake does not have entries
	# for header files. So we do our best by asking the db for flags for a
	# corresponding source file, if any. If one exists, the flags for that file
	# should be good enough.
	if IsHeaderFile( filename ):
		basename = os.path.splitext( filename )[ 0 ]
		for extension in SOURCE_EXTENSIONS:
			replacement_file = basename + extension
			if os.path.exists( replacement_file ):
				compilation_info = database.GetCompilationInfoForFile(
			  	replacement_file )
			if compilation_info.compiler_flags_:
				return compilation_info
			return None
		return database.GetCompilationInfoForFile( filename )


	def FlagsForFile( filename, **kwargs ):
	if not database:
		return {
			'flags': flags,
			'include_paths_relative_to_dir': DirectoryOfThisScript()
		}

	compilation_info = GetCompilationInfoForFile( filename )
		if not compilation_info:
			return None

	# Bear in mind that compilation_info.compiler_flags_ does NOT return a
	# python list, but a "list-like" StringVec object.
	final_flags = list( compilation_info.compiler_flags_ )

	# NOTE: This is just for YouCompleteMe; it's highly likely that your project
	# does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
	# ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
	try:
		final_flags.remove( '-stdlib=libc++' )
	except ValueError:
		pass

	return {
		'flags': final_flags,
		'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
	}


python stuff, virtual envs
`````````````````````````````

.. code-block:: bash

	sudo -H pip install virtualenv
	sudo -H pip install virtualenvwrapper

	### configure virtualenvwrapper:
	### edit ~/.zshrc:

	export WORKON_HOME=$HOME/.virtualenvs
	export PROJECT_HOME=$HOME/Devel
	source /usr/local/bin/virtualenvwrapper.sh

	# to create new virtual env:

	mkvirtualenv temp


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
