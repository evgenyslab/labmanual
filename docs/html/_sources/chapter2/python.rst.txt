.. comment:

Python Development
==================

This guide outlines my approach for python development and methodologies used.

.. drawio-figure:: art/diagram_ch2.drawio
   :format: png

   An example diagram

NUMPY CHEET SHEET
-----------------

.. code-block:: bash

	import numpy as np

	# Input is a set of object points for N objects, M, points:
	# N x [3xM]
	arr = [
	    [111, 112, 113, 121, 122, 123, 131, 132, 133, 141, 142, 143],
	    [211, 212, 213, 221, 222, 223, 231, 232, 233, 241, 242, 243],
	    [311, 312, 313, 321, 322, 323, 331, 332, 333, 341, 342, 343],
	    [411, 412, 413, 421, 422, 423, 431, 432, 433, 441, 442, 443],
	    [511, 512, 513, 521, 522, 523, 531, 532, 533, 541, 542, 543]
	]

	# Create array:
	A = np.array(arr)

	N = 5
	M = 4
	D = 3  # 2D or 3D

	# convert into more useful shape:
	# N x M x 3
	B = A.reshape([-1, M, D])
	# Conver to something more friendly for R*B multiplacations:
	# N x 3 x M:
	B = B.swapaxes(1,2)
	# create Rotation Matrix (axis swap):
	R = np.array([[0, 1 ,0],
	             [1, 0, 0],
	             [0, 0, 1]])
	# apply:
	np.matmul(R, B)


TODOs
-------


Create alias for quick activation of virtual environment in local directory:

.. code-block:: bash

	alias activate="source .venv/bin/activate"

- [ ] python project structure
- [ ] using setup.py to install python models

  -  [ ] installing custom python modules into virtual environments

- [ ] development with Jupyterlab

  - [ ] remote development - using ssh forwarding

- [ ] development with pycharm

- [ ] remote development and debugging over ssh


Jupyter remote
----------------

1. Make sure host device has ssh enabled, if using Ubuntu:

.. code-block:: bash

	$ sudo apt-get install openssh-server

2. setup local jupyter notebook on host device:

.. code-block:: bash

	$ jupyter notebook --no-browser --port=8889

3. on local machine, run ssh tunneling into host machine with remapping ports:

.. code-block:: bash

	$ ssh -N -f -L localhost:8888:localhost:8889 host_machine_username@host_machine_ip
	$ ssh -N -f -L localhost:8888:localhost:8889 user@192.168.0.111

4. to access the notebook on the remote machine (i.e. mac), in browser navigate to:
:code:`localhost:8888`

There may be a password/token required, to view it, look at the ssh'ed session
in (2) that is running the jupyter notebook, it will provide the token.

5. Connection may be rejected on local side if the port has not been properly closed.

.. code-block:: bash

	# Can investigate to ses which PID is using the port with:
	lsof -it:8888
	# This will return the PID of the process using the port. This process can be killed with:
	lsof -it:8888 xargs kill -9

Virtual Environment Script
-----------------------------

.. code-block:: bash

	#!/bin/bash
	# setup some colors:
	BLACK='\033[0;30m'
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	YELLOW='\033[0;33m'
	BLUE='\033[0;34m'
	PURPLE='\033[0;35m'
	CYAN='\033[0;36m'
	NC='\033[0m' # No Color

	var="$PWD/.venv"

	if [ -d "${var}" ]; then
		echo -e "${YELLOW}Virtaul environment exists${NC}."
		echo -e "${RED}Removing existing environment...${NC}"
		rm -r ${var}
		echo -e "${YELLOW}Environment removed!${NC}"
	else
		echo -e "${GREEN}Virtaul environment does not exists${NC}."
	fi

	echo -e "${CYAN}Creating new PYTHON3 virtual environment in ${var}${NC}"
	virtualenv -p /usr/bin/python3 ${var}
	source ${var}/bin/activate
	echo -e "${GREEN}Installing python packages...${NC}"
	pip -q install -r requirements.txt
	echo -e "${GREEN}Virtual Environment Install Complete! use 'source .venv/bin/activate' to enable!${NC}"



SOME THOUGHTS about python wrapping:

- when creating C++ cython wrapped application, should build be called
  followed by setup.py, or should setup.py do its own build? 
  I suspect the order of events will affect the library install... i.e.
  a static library might be correctly link, but shared might not.

- I think all used libraries in c++ code need to be defined in 
  setup.py's `library` list.

- if a c++ cmake has shared library as part of the install, it 
  needs to be installed into `/lib` for python to locate it.

- Two possible use cases - C++ is installed for c++ library use, then
  python wrapping is added on top and installed into specific 
  python environment, wherein python folder has its own cmakelist 
  and is used as a subdirectory in c++ cmake list, OR
  C++ and python are treated separately, and python's setup.py 
  calls the compilation itself (would work with static libs), in that case
  no c++ libraries are made available for C++ work.
