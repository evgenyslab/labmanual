.. Comment

    # with overline, for parts
    * with overline, for chapters
    =, for sections
    -, for subsections
    ^, for subsubsections
    “, for paragraphs

macOS Configuration
===================

The macOS is built on a linux-like system, however, unlike common linux distros,
it is missing a package manager (i.e. :code:`apt`). 


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

   # Install zsh
   brew install zsh

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

.. rli:: https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/zshsauce
 
This can be quickly added to your :code:`~/.zshrc` using the following command:

.. code-block:: bash

    `wget https://raw.githubusercontent.com/evgenyslab/labmanual/master/docs/zshsauce -O ->> ~/.zshrc` 


VIM
^^^

Vim is a terminal editor that is very portable. My take on the configuration of vim
can be found |xref_vim_config|.



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

