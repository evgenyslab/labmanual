.. comment:

Python
======


TODOs
-------


Create alias for quick activation of virtual environment in local directory:

.. code-block:: bash

	alias activate="source .venv/bin/activate"


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

