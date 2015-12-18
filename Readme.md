# Eigen to Numpy with Swig

[![Build Status](https://travis-ci.org/rdeits/swig-eigen-numpy.svg)](https://travis-ci.org/rdeits/swig-eigen-numpy)

## Introduction

This package exists as a demonstration of some of the tools I've been playing with to wrap C++ libraries which use Eigen Matrix types in Python (using numpy arrays). Specifically, it demonstrates:

* Wrapping a C++ class in a Python class
* Passing numpy arrays to and from C++ methods which accept and return Eigen Matrix types
* Adding additional Python-defined methods to a C++ class
* Calling templated C++ functions from Python.
* Calling C++ methods which take Eigen::Ref arguments from Python
* Support for Python 2.7 and Python 3

To show this off, I've written a C++ function which uses Eigen's LU module to invert matrices. This is a trivially simple example, but hopefully it will make someone's life a little easier down the road.

## Requirements

You'll need, at the very least:

* cmake
* swig
* a c/c++ compiler for your system

On OSX, you can follow the instructions from Homebrew to [install a compiler](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md#requirements) and use [Homebrew](http://brew.sh/) to install the `cmake swig` packages. On Ubuntu, you can `sudo apt-get install cmake swig`.

If you don't have a copy of `eigen3` installed, one will be automatically downloaded and built for you. If you don't want that, just install the `eigen3` package yourself. In Homebrew it's called `eigen` and in `apt-get` it's called `libeigen3-dev`. 

## Building

This project is entirely configured using CMake, so building should be pretty easy. Just:

	mkdir build
	cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=../install
	make
	make install

Nothing should get installed into your system; instead, the `inverter` library will get put in `install/lib/`. If you want to install globally, then you can just remove the `-DCMAKE_INSTALL_PREFIX=../install` argument.

## Using the python bindings

You'll need to make sure that the `inverter` shared library is accessible to your system at runtime. If you installed globally (without the `-DCMAKE_INSTALL_PREFIX=../install` argument), then you're all set. Otherweise, on OSX, you can do:

	export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/path/to/wherever/you/put/swig-eigen-numpy/install/lib"

Or on Linux:

	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/path/to/wherever/you/put/swig-eigen-numpy/install/lib"

That will only affect the current instance of your terminal. To make that change permanent, put that line inside your `~/.bashrc` file.

The python bindings are demonstrated in `python/test_inverter.py`. To run it, just do:

	cd python
	python test_inverter.py

## Structure of this repo

### `src`
contains our c++ library, header, and a test executable

### `python`
contains the main swig interface file and our python source code

### `swigmake/swig`
contains general-purpose swig interface files for eigen and numpy

### `swigmake/cmake`
contains some helper scripts for cmake to find the eigen and numpy libraries


## Python 3 support

This project should build and run correctly on Python 2 or Python 3. To change python versions, you can add another argument to cmake:

	mkdir build
	cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=../install -DPYTHON_EXECUTABLE=`which python3`
	make
	make install
	cd ../python
	python3 test_inverter.py

In the above code I've told cmake to build with python3 instead of my default python2.

