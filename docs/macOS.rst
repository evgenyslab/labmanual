.. Comment

macOS Configuration
===================

- install `Brew <https://brew.sh/>`_
- install `oh-my-zsh <https://ohmyz.sh/>`_
- install brew cmake :code:`brew install cmake` (may need change some ownership here and there)
- install brew python: :code:`brew install python`
- confirm default python is brew's not system ?
- install virtualenvs: :code:`sudo -H pip3 install virtualenv`
- install macvim :code:`brew install macvim`
- add alias in :code:`~/.zshrc` :code:`alias mkvenv="virtualenv -p $(which python3) .venv`
- add alias in :code:`~/.zshrc` :code:`alias activate="source ./venv/bin/activate`
- add alias in :code:`~/.zshrc` :code:`alias vim="mvim -v"`
- install GTEST
- install docker


TODO:

- Look into vtop (requires NPM) - NPM install?
- look into fzf (fuzzy finder in terminal)
- VIM configuration (as layers)
  -> I want to learn this and configure as replacement for atom.
  -> what packages?
  -> what commands?
  -> find?
  -> find in dir?
  -> replace?
-

Tips & Tricks
-------------

use :code:`mdls` command to retrieve meta data on any file, useful for scripting file renaming. If the command returns :code:`(null)` it means spotlight search needs to be rebuilt on the drive using :code:`sudo mdutil -E /Drive`.


-> TODO: remote development with a linux parallels image using ssh:

Seems like with parallels, I only need to use port forwarding from host to parallels since
parallels is on an IP:

ssh -N -f -L localhost:2220:localhost:22 en@192.168.1.201
^ this maps remote 2220 to local 22 port

Then in jetbrains clion - set up remote env

wherein parallels image is sitting on a LAN IP
