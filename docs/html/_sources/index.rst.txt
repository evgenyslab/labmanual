.. test documentation master file, created by
   sphinx-quickstart on Wed Nov  6 14:47:06 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
    
   HEADINGS:

   # with overline, for parts
   * with overline, for chapters
   =, for sections
   -, for subsections
   ^, for subsubsections
   “, for paragraphs

.. General Layout
   
    HOME
        High level info about this pages
    
    OSCONFIGURATIONS
        What is the purpose of the config? what am I trying to solve?
   
        Common
            Common Configuration Philosophy (zsh, vim, docker, jetbrains)
        Linux
            OS Installations
            Packages
            Package-configs
            Tips & tricks
        Linux-Server
            OS Installations
            Packages
            Package-configs
            Tips & tricks
        macOS
            OS Installations
            Packages
            Package-configs
            Tips & tricks
        Tips & Tricks
            SSH port forwarding (xref to jupyterlab)
            SSH Tunnel coping
            


    Development Approaches
        Problem definition? what am I trying to achieve in development?
        How does it relate to the original principle?
        Choice of language, considations or os
        C++
            ?
            Template Projec
                docs, cmake, readme, install reqs
        Python
            Template Project
                docs, setup, req, readme - package, init
            python versions
            virtual envs
            IDE
            non-IDE
            Jupyter
                local
                remote
                docker /+ remote
            Troubles with Conda/ python path; ros, etc

        JS
            ?

        Databaases
            postgress/etc

        Local vs Remote
            Methods per language
            Approaches
            Docker / remote Computer

        JetBrains
            Local
            Remote - Docker
            Remote - OS

        Knowledgebase
            Development
                VIM
                OPENCV
                PYTHON
            CAMERA

            .. Math/science/etc



LAB MANUAL
================================

This is the lab manual, a resource for all things setup related and navigation.

.. toctree::
   :maxdepth: 1
   :numbered:
   :caption: Contents:
   
   chapter1/home
   chapter1/OSConfigurations
   chapter1/Development
   chapter2/docker
   chapter2/vim
   chapter2/aws
   chapter2/opencv
   chapter2/misc
   chapter3/projects
   chapter3/python
   chapter3/pytorch
   chapter3/random
   chapter3/camera
   readme



Indices and tables
==================

* :ref:`genindex`
* :ref:`search`
