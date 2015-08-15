%module(directors="1") inverter_wrapper

%{
#define SWIG_FILE_WITH_INIT
#include <Python.h>
#include "inverter.hpp"
%}

%init
%{
	import_array();
%}

%include <typemaps.i>
%include <eigen.i>

%eigen_typemaps(Eigen::VectorXd)
%eigen_typemaps(Eigen::MatrixXd)

%include "inverter.hpp"

%feature("director") Inverter;
