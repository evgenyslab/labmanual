.. comment

OpenCV
======

OpenCV Installation
-------------------

1. clone both opencv and opencv-contrib into local directories

.. code-block:: bash

	cd opencv_contrib
	git checkout <version>
	cd ../opencv
	git checout <version>

	mkdir build
	cd build


2. Setup cmake command:

.. code-block:: bash

	cmake -DCMAKE_BUILD_TYPE=Release \
	-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=/usr/local \..


OpenCV with Cuda:

.. code-block:: bash

	cmake -DCMAKE_BUILD_TYPE=Release \
	-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-DCUDA_ARCH_BIN=7.0 \
	-DCUDA_ARCH_PTX=7.0 \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=/usr/local \
	-DWITH_TBB=ON \
	-DBUILD_NEW_PYTHON_SUPPORT=ON \
	-DWITH_V4L=ON \
	-DBUILD_TIFF=ON \
	-DWITH_QT=ON \
	-DWITH_OPENGL=ON \
	-DENABLE_FAST_MATH=1 \
	-DCUDA_FAST_MATH=1 \
	-DWITH_CUBLAS=1 \
	-DINSTALL_PYTHON_EXAMPLES=ON \
	-DBUILD_EXAMPLES=ON \
	-DCUDA_GENERATION=Volta \
	-DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" ..

The alternative is to install a docker contrainer with opencv with cuda/cudnn installed, and then
use Jupyterlab to remote into it.

3. Install

.. code-block:: bash

	make install -j8
	sudo make install
