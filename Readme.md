# Eigen to Numpy with Swig

## Introduction

This package exists as a demonstration of some of the tools I've been playing with to wrap C++ libraries which use Eigen Matrix types in Python (using numpy arrays). Specifically, it demonstrates:

* Wrapping a C++ class in a python class
* Passing numpy arrays to and from C++ methods which accept and return Eigen Matrix types
* Adding additional Python-defined methods to a C++ class
* Calling templated C++ functions from Python. 

To show this off, I've written a C++ function which uses Eigen's LU module to invert matrices. This is a trivially simple example, but hopefully it will make someone's life a little easier down the road. 

## Requirements

You'll need, at the very least:

* cmake
* eigen3
* swig
* a c/c++ compiler for your system

On OSX, you can follow the instructions from Homebrew to [install a compiler](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md#requirements) and use [Homebrew](http://brew.sh/) to install the `cmake swig eigen` packages. On Ubuntu, you can `sudo apt-get install libeigen3-dev cmake swig`. 

## Building

This project is entirely configured using CMake, so building should be pretty easy. Just:

	mkdir build
	cd build
	cmake ..
	make
	make install

Nothing should get installed into your system. The `make install` step just puts the python libraries inside the python package. 

## Using the python bindings

The python bindings are demonstrated in `python/test_inverter.py`. To run it, just do:

	cd python
	python test_inverter.py

