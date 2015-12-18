// Tell swig the name of the module we're creating
%module inverter_wrapper

// Pull in the headers from Python itself and from our library
%{
#define SWIG_FILE_WITH_INIT
#include <Python.h>
#include "inverter.hpp"
%}

// typemaps.i is a built-in swig interface that lets us map c++ types to other
// types in our language of choice. We'll use it to map Eigen matrices to
// Numpy arrays.
%include <typemaps.i>
%include <std_vector.i>

// eigen.i is found in ../swig/ and contains specific definitions to convert
// Eigen matrices into Numpy arrays.
%include <eigen.i>

%template(vectorMatrixXd) std::vector<Eigen::MatrixXd>;
%template(vectorVectorXd) std::vector<Eigen::VectorXd>;

// Since Eigen uses templates, we have to declare exactly which types we'd
// like to generate mappings for.
%eigen_typemaps(Eigen::VectorXd)
%eigen_typemaps(Eigen::MatrixXd)
// Even though Eigen::MatrixXd is just a typedef for Eigen::Matrix<double,
// Eigen::Dynamic, Eigen::Dynamic>, our templatedInverse function doesn't
// compile correctly unless we also declare typemaps for Eigen::Matrix<double,
// Eigen::Dynamic, Eigen::Dynamic>. Not totally sure why that is.
%eigen_typemaps(Eigen::Matrix<double, Eigen::Dynamic, Eigen::Dynamic>)

// Tell swig to build bindings for everything in our library
%include "inverter.hpp"

// Create a specific instantiation of the templatedInverse function for
// arguments of type double, and call it templatedInverse_d. We'll import
// templatedInverse_d in pyinverter/pyinverter.py.
%template(templatedInverse_d) templatedInverse<double>;

// Add a python snippet to the generated file. This snippet attaches the
// Inverter_getInversePlus1 function from extensions.py as a new method of
// Inverter. That lets us define additional python-only methods that can act
// on the Inverter object.
%pythoncode %{
from .extensions import Inverter_getInversePlus1
Inverter.getInversePlus1 = Inverter_getInversePlus1
%}
