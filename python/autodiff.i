%module(package="pyad") autodiff

%{
#ifdef SWIGPYTHON
  #define SWIG_FILE_WITH_INIT
  #include <Python.h>
#endif
#include "square.hpp"
#include <unsupported/Eigen/AutoDiff>
#include <iostream>
%}

%include <eigen.i>

%fragment("AutoDiff_Fragments", "header", fragment="Eigen_Fragments") 
%{
  int PyObject_obeys_taylorvar_interface(PyObject* obj) {
    if (!PyObject_HasAttrString(obj, "value")) {
      return 0;
    } else if (!PyObject_HasAttrString(obj, "derivatives")) {
      return 0;
    } else {
      return 1;
    }
  }

  // template <typename DerType>
  // bool ConvertFromTaylorVarToAutoDiffMatrix(Eigen::MatrixBase<Eigen::AutoDiffScalar<DerType>, Eigen::Dynamic, Eigen::Dynamic
%}



// %eigen_typemaps(Eigen::VectorXd)
// %eigen_typemaps(Eigen::MatrixXd)
// %eigen_typemaps(Eigen::Matrix<double, Eigen::Dynamic, Eigen::Dynamic>)

%typecheck(2200, fragment="AutoDiff_Fragments") 
  Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd >, Eigen::Dynamic, Eigen::Dynamic> {
  std::cout << "running autodiff matrix typecheck" << std::endl;
  $1 = PyObject_obeys_taylorvar_interface($input);
}

%typecheck(2100, fragment="AutoDiff_Fragments") 
  Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd >, Eigen::Dynamic, 1> {
  std::cout << "running autodiff vector typecheck" << std::endl;

  if (!PyObject_obeys_taylorvar_interface($input)) {
    $1 = 0;
  } else {
    PyObject * value = PyObject_GetAttrString($input, "value");
    PyArrayObject* value_array = obj_to_array_no_conversion(value, array_type(value));
    if (!value_array) {
      $1 = 0;
    } else {
      $1 = (PyArray_NDIM(value_array) == 1 || (PyArray_NDIM(value_array) == 2 && PyArray_DIM(value_array, 2) == 1));
    }
  }
}

%typemap(in, fragment="Eigen_Fragments") Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> {
  std::cout << "running autodiff matrix input typemap" << std::endl;
  PyObject * value = PyObject_GetAttrString($input, "value");
  int value_array_is_new_object = 0;
  PyArrayObject* value_array = obj_to_array_allow_conversion(value, NPY_DOUBLE, &value_array_is_new_object);
  if (!value_array) {
    std::cout << "could not convert value to double array" << std::endl;
    SWIG_fail;
  }
  PyObject* derivatives = PyObject_GetAttrString($input, "derivatives");
  if (!derivatives || !PySequence_Check(derivatives) || PyObject_Length(derivatives) == 0) {
    std::cout << "could not get non-empty derivatives property" << std::endl;
    SWIG_fail;
  }
  PyObject* first_derivatives = PySequence_GetItem(derivatives, 0);
  if (!first_derivatives) {
    std::cout << "could not get first derivatives" << std::endl;
    SWIG_fail;
  }
  PyArrayObject* derivatives_array = obj_to_array_no_conversion(first_derivatives, NPY_OBJECT);
  if (!derivatives_array) {
    std::cout << "could not convert derivatives to object array" << std::endl;
    SWIG_fail;
  }

  int m = PyArray_DIM(value_array, 0);
  int n;
  int ndim = PyArray_NDIM(value_array);
  if (PyArray_NDIM(derivatives_array) != ndim) {
    std::cout << "ndim of value and derivatives[0] must match" << std::endl;
    SWIG_fail;
  }
  for (int i=0; i < ndim; i++) {
    if (PyArray_DIM(value_array, i) != PyArray_DIM(derivatives_array, i)) {
      std::cout << "dimensions of value and derivatives[0] must match" << std::endl;
      SWIG_fail;
    }
  }
  if (ndim > 2 || ndim < 1) {
    std::cout << "ndim must be 1 or 2" << std::endl;
    SWIG_fail;
  }
  if (ndim > 1) {
    n = PyArray_DIM(value_array, 1);
  } else {
    n = 1;
  }

  Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> res(m, n);
  for (size_t i=0; i < m; i++) {
    for (size_t j = 0; j < n; j++) {
      PyArrayObject* d;
      double* v;
      if (ndim == 1) {
        v = (double*) PyArray_GETPTR1(value_array, i);
        d = obj_to_array_no_conversion(*((PyObject**) PyArray_GETPTR1(derivatives_array, i)), NPY_DOUBLE);
      } else {
        v = (double*) PyArray_GETPTR2(value_array, i, j);
        d = obj_to_array_no_conversion(*((PyObject**) PyArray_GETPTR2(derivatives_array, i, j)), NPY_DOUBLE);
      }
      if (!d || PyArray_NDIM(d) != 1) {
        std::cout << "could not convert derivative at i: " << i << " j: " << j << " to double array" << std::endl;
        SWIG_fail;
      }

      Eigen::VectorXd derivatives(PyArray_DIM(d, 0));
      for (size_t k=0; k < PyArray_DIM(d, 0); k++) {
        derivatives(k) = *((double*) PyArray_GETPTR1(d, k));
      }
      res(i,j) = Eigen::AutoDiffScalar<Eigen::VectorXd>(*v, derivatives);
      // std::cout << "i: " << i << " j: " << j << " v: " << *v << " res(i,j): " << res(i,j).value() << std::endl;
    }
  }

  $1 = res;
  Py_DECREF(value);
  Py_DECREF(derivatives);
  Py_DECREF(first_derivatives);
  if (value_array_is_new_object) {
    Py_DECREF(value_array);
  }
}

%typemap(out, fragment="Eigen_Fragments") Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> {
  std::cout << "running autodiff matrix output map" << std::endl;
  size_t m = $1.rows();
  size_t n = $1.cols();

  PyObject* sys_mod_dict = PyImport_GetModuleDict();
  if (!sys_mod_dict) {
    std::cout << "could not get sys mod dict" << std::endl;
    SWIG_fail;
  }
  PyObject* taylor_mod = PyMapping_GetItemString(sys_mod_dict, "taylor");
  if (!taylor_mod) {
    std::cout << "could not get taylor module" << std::endl;
    SWIG_fail;
  }

  npy_intp dims[] = {m, n};
  PyObject* value = PyArray_SimpleNew(2, dims, NPY_DOUBLE);
  PyArrayObject* value_array = obj_to_array_no_conversion(value, NPY_DOUBLE);
  PyObject* first_derivatives = PyArray_SimpleNew(2, dims, NPY_OBJECT);
  PyArrayObject* derivatives_array = obj_to_array_no_conversion(first_derivatives, NPY_OBJECT);

  for (int i=0; i < m; i++) {
    for (int j=0; j < n; j++) {
      double* v = (double*) PyArray_GETPTR2(value_array, i, j);
      *v = $1(i, j).value();
      PyObject ** d = (PyObject**) PyArray_GETPTR2(derivatives_array, i, j);
      npy_intp num_derivatives = $1(i, j).derivatives().size();
      *d = PyArray_SimpleNew(1, &num_derivatives, NPY_DOUBLE);
      PyArrayObject* d_array = obj_to_array_no_conversion(*d, NPY_DOUBLE);
      for (int k=0; k < num_derivatives; k++) {
        double* d_val = (double*) PyArray_GETPTR1(d_array, k);
        *d_val = $1(i, j).derivatives()(k);
      }
    }
  }

  PyObject* derivatives = PyTuple_New(1);
  PyTuple_SetItem(derivatives, 0, first_derivatives);

  $result = PyObject_CallMethodObjArgs(taylor_mod, PyString_FromString("TaylorVar"), value, derivatives, NULL);
  Py_DECREF(value);
  Py_DECREF(derivatives);
}

%include "square.hpp"
Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> x);
Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> x);
