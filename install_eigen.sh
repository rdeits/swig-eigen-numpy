#!/bin/bash

# The version of libeigen3-dev available on Ubuntu 14.04 will work fine with this project. However, the version avaialable from apt-get on Ubuntu 12.04 is too old. This script is used by the Travis build server to install a newer version of Eigen.

sudo apt-get update -qq
sudo apt-get install cmake swig libxmu libxmu-headers
wget --no-check-certificate "http://bitbucket.org/eigen/eigen/get/3.2.5.tar.bz2"
bzip2 -d 3.2.5.tar.bz2
tar -xf 3.2.5.tar
cd eigen-eigen-bdd17ee3b1b3
mkdir build
cd build
cmake ..
sudo make install
cd ../..