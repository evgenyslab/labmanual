# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# This will add all folder in under source dir:
import os
import sys
import warnings
sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'LAB Manual'
copyright = '2021, Evgeny'
author = 'Evgeny Nuger'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'm2r2',
    'sphinx.ext.autosectionlabel',
    'sphinx_rtd_theme',
    'sphinxext.remoteliteralinclude',
    'sphinxcontrib.drawio',
        ]

# Auto generate internal links on section labels;
# WARNING: may not work well when labels repeat.
autosectionlabel_prefix_document = True

# Test for Drawio and link if available
if os.path.isfile('/Applications/draw.io.app/Contents/MacOS/draw.io'): 
    drawio_binary_path = '/Applications/draw.io.app/Contents/MacOS/draw.io'
elif os.path.isfile('/usr/bin/drawio'):
    drawio_binary_path = '/usr/bin/drawio'
else:
    drawio_binary_path = None
    warnings.warn('Could not locate Drawio app')

if drawio_binary_path is not None:
    # Drawio settings:
    drawio_default_transparency = True


# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

source_suffix = ['.rst', '.md']
# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
