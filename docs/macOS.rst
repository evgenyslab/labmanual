.. Comment

macOS - 10.15 Catelina
======================

- install `Brew <https://brew.sh/>`_
- install `oh-my-zsh <https://ohmyz.sh/>`_
- install brew cmake :code:`cmake install brew` (may need change some ownership here and there)
- install brew python: :code:`brew install python`
- confirm default python is brew's not system ?
- install virtualenvs: :code:`sudo -H pip3 install virtualenv`
- add alias in :code:`~/.zshrc` :code:`alias mkvenv="virtualenv -p $(which python3) .venv`
- add alias in :code:`~/.zshrc` :code:`alias activate="source ./venv/bin/activate`
- create :code:`~/.vimrc` and add :code:`set nu \r syntax on`

- install GTEST
- install docker

Tips & Tricks
-------------

use :code:`mdls` command to retrieve meta data on any file, useful for scripting file renaming. If the command returns :code:`(null)` it means spotlight search needs to be rebuilt on the drive using :code:`sudo mdutil -E /Drive`.
