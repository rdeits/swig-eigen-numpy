%module(package="pyad") autodiff

%{
#ifdef SWIGPYTHON
  #define SWIG_FILE_WITH_INIT
  #include <Python.h>
#endif
#include "square.hpp"
#include <iostream>
%}


%include <eigen.i>
%include <autodiff.i>

%autodiff_typemaps(2200, 1, Eigen::VectorXd)
%autodiff_typemaps(2201, Eigen::Dynamic, Eigen::VectorXd)

%include "square.hpp"
Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> x);
Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> x);

