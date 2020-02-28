.. Comment

Miscellaneous Guides
====================

Ipsum

Mount Remote Directory Locally in Linux
---------------------------------------

In the case of remote development, it may be beneficial to mount the remote's development
path on the local computer, use a local file editor to make and save changes, and then
compile and run remotely.

In linux, to mount a remote directory from a remote machine, use :code:`ssfs`:

.. code-block:: bash

	sudo apt-get install ssfs

Then, it is neccesary to create a local directory into which the remote will mount:

.. code-block:: bash

	mkdir /my/local/mount/point

Finally, use :code:`ssfs` to mount the remote directory into the newly created local:

.. code-block:: bash

	sudo sshfs -o allow_other remote_user@10.10.10.10:/remote/path/to/mount/ /my/local/mount/point


Source: [|ref_01|].

Linux / Mac Splitting TAR Files
-------------------------------

To create tar archive:

.. code-block:: bash

	# first tar the folder:
	tar -cvzf tarFileName.tar.gz /Directory/To/Tar/*

	# then split the folder:
	split -b 2000m tarFileName.tar.gz "tarFileName.tar.gz.part"

	# to recombine:
	cat tarFileName.tar.gz.part* > tarFileName.tar.gz

Sphinx & GitHub Pages
---------------------

Source: [|ref_00|].

GDB Remote Debugging C++
------------------------

ipsum



.. |ref_00| raw:: html

   <a href="https://daler.github.io/sphinxdoc-test/includeme.html" target="_blank">ref</a>

.. |ref_01| raw:: html

   <a href="https://www.tecmint.com/sshfs-mount-remote-linux-filesystem-directory-using-ssh/" target="_blank">ref</a>
