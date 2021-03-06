.. Comment

Miscellaneous Guides
====================


+------------+------------+-----------+
| Header 1   | Header 2   | Header 3  |
+============+============+===========+
| body row 1 | column 2   |           |
|            | more info  | column 3  |
+------------+------------+-----------+


Doxygen Notes
-------------

To generate pdf output from doxygen, make sure to have latex output set,
and then in latex directory run :code:`make`.

Doxygen config items:

- [ ] project name
- [ ] inputs
- [ ] adding directive to parse pyx files (see cython_examples)
- [ ] generating UML class digrams
- [ ] OS pre-reqs for linux/max

Mount Remote Directory Locally in Linux
---------------------------------------

In the case of remote development, it may be beneficial to mount the remote's development
path on the local computer, use a local file editor to make and save changes, and then
compile and run remotely.

In linux, to mount a remote directory from a remote machine, use :code:`sshfs`:

.. code-block:: bash

	sudo apt-get install sshfs

Then, it is neccesary to create a local directory into which the remote will mount:

.. code-block:: bash

	mkdir /my/local/mount/point

Finally, use :code:`sshfs` to mount the remote directory into the newly created local:

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

Local app install
---------------------
Application executibles can be installed by placing a sh script to launch the application
under `$HOME/.local/bin`, this will be visible to the current user.

Sphinx & GitHub Pages
---------------------

Source: [|ref_00|].

IMPORTANT NOTE: github uses jekyll to generate pages, however, standard
sphinx doc structure has a :code:`_static` folder generate with 
all css and js files. When Github tried to compile the site with 
:code:`jekyll`, files/folders with :code:`_` are ignored. 

**THEREFORE** when using the gh-pages branch side-by-side repo config
as per the instructions in the ref, it is important to add :code:`.nojekyll` 
in the root directory. This allows style sheets and js to work correctly.

**FOLLOW UP** I'll look into hosting the docs right from main repo,
gh-pages seems to be able to support that now, could be very useful!

TODO: Add conf.py info for relative paths!

Drawio w/ Sphinx
^^^^^^^^^^^^^^^^

see: https://pypi.org/project/sphinxcontrib-drawio/

To get this to work, need to make sure :code:`sphinxcontrib-drawio` to
the extensions in :code:`conf.py` for docs.

Then, need to add the application executible for sphinx to render
the drawing by adding :code:`drawio_binary_path='/path/to/app'`
in the :code:`conf.py` configuraiton file.

Then, Images can be rendered and exported using a modified image
directive.

Note, drawio page id can be used to specify which page of the 
diagram to export.

The drawio diagrams can be stored in a relative location to source,
during document compilation, drawio will be used to render the image
and place it in appropriate folder under html build directory.

.. drawio-figure:: art/diagram00.drawio
   :format: png

   An example diagram


GDB Remote Debugging C++
------------------------

TODO:

- go to build location of executible
- make sure to build with debug
- run `gdb myexecutible` to open gdb interface
- then, to set break point, use \`\`?
- to run with debug use `-r arg1 arg2...`
- on segfault/etc, use `bt` to back trace where the failure occured



.. |ref_00| raw:: html

   <a href="https://daler.github.io/sphinxdoc-test/includeme.html" target="_blank">ref</a>

.. |ref_01| raw:: html

   <a href="https://www.tecmint.com/sshfs-mount-remote-linux-filesystem-directory-using-ssh/" target="_blank">ref</a>
