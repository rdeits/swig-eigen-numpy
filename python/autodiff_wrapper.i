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

%template(AutoDiffVectorDynamic) AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1>;
%template(AutoDiffMatrixDynamic) AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, Eigen::Dynamic>;

%pythoncode %{
import numpy as np

def newAutoDiff(value, derivatives=None):
    value = np.asarray(value)
    if derivatives is None:
        derivatives = np.eye((value.size, value.size))
    else:
        derivatives = np.asarray(derivatives)
    if value.ndim == 0:
        value = value.reshape((1,))
    if value.ndim < 2:
        return AutoDiffVectorDynamic(value, derivatives)
    else:
        return AutoDiffMatrixDynamic(value, derivatives)

def newAutoDiffLike(template, value):
    value = np.asarray(value, dtype=np.float64).reshape((template.rows(), template.cols()), order='F')
    derivatives = np.zeros_like(template.derivatives())
    return newAutoDiff(value, derivatives)
%}



%include "square.hpp"

AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1> squareVector(AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1>);
AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, Eigen::Dynamic> squareMatrix(AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, Eigen::Dynamic>);

