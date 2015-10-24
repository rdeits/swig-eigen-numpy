%module(package="pyad") autodiff

%{
#ifdef SWIGPYTHON
  #define SWIG_FILE_WITH_INIT
  #include <Python.h>
#endif
#include "square.hpp"
#include <unsupported/Eigen/AutoDiff>
#include <iostream>

Eigen::AutoDiffScalar<Eigen::VectorXd> adnumber_to_eigen(PyObject* adnum) {
  PyObject* keys = PyObject_CallMethod(PyObject_CallMethod(adnum, "d", ""), "keys", "");
  Eigen::VectorXd derivatives(PyObject_Length(keys));
  for (size_t i=0; i < derivatives.size(); i++) {
    derivatives(i) = PyFloat_AsDouble(PyObject_CallMethodObjArgs(adnum, PyString_FromString("d"), PySequence_GetItem(keys, i), NULL));
  }
  Eigen = Eigen::AutoDiffScalar<Eigen::VectorXd>(PyFloat_AsDouble(PyObject_GetAttrString(adnum, "x")), derivatives);

}
%}

%include <typemaps.i>
%include <std_vector.i>
%include <eigen.i>

%template(vectorVectorXd) std::vector<Eigen::VectorXd>;
%template(vectorMatrixXd) std::vector<Eigen::MatrixXd>;

%eigen_typemaps(Eigen::VectorXd)
%eigen_typemaps(Eigen::MatrixXd)
%eigen_typemaps(Eigen::Matrix<double, Eigen::Dynamic, Eigen::Dynamic>)
%eigen_typemaps(Eigen::VectorXi)

%include "square.hpp"

%typemap(typecheck, precedence=2100) Eigen::MatrixBase<Eigen::AutoDiffScalar<Eigen::VectorXd>> {
  std::cout << "running autodiff vector typecheck" << std::endl;
  if (!is_array($input)) {
    $1 = 0;
  } else if (PyArray_NDIM($input) < 1 || PyArray_NDIM($input) > 2) {
    $1 = 0;
  } else if (!PyArray_ISOBJECT($input)) {
    $1 = 0;
  } else if (PyObject_Length($input) == 0) {
    $1 = 0;
  } else if (!PyObject_HasAttrString(PySequence_GetItem($input, 0), "x")) {
    $1 = 0;
  } else if (!PyObject_HasAttrString(PySequence_GetItem($input, 0), "d")) {
    $1 = 0;
  } else {
    $1 = 1;
  }
}

%typemap(typecheck, precedence=2000) Eigen::AutoDiffScalar<Eigen::VectorXd> {
  std::cout << "running autodiff typecheck" << std::endl;
  if (!PyObject_HasAttrString($input, "x")) {
    $1 = 0;
  } else if (!PyObject_HasAttrString($input, "d")) {
    $1 = 0;
  } else {
    $1 = 1;
  }
}

%typemap(in) Eigen::MatrixBase<Eigen::AutoDiffScalar<Eigen::VectorXd> > {
  std::cout << "running autodiff vector input typemap" << std::endl;
}

%typemap(in) Eigen::AutoDiffScalar<Eigen::VectorXd> {
  std::cout << "running autodiff input typemap" << std::endl;
  PyObject* keys = PyObject_CallMethod(PyObject_CallMethod($input, "d", ""), "keys", "");
  Eigen::VectorXd derivatives(PyObject_Length(keys));
  for (size_t i=0; i < derivatives.size(); i++) {
    derivatives(i) = PyFloat_AsDouble(PyObject_CallMethodObjArgs($input, PyString_FromString("d"), PySequence_GetItem(keys, i), NULL));
  }
  $1 = Eigen::AutoDiffScalar<Eigen::VectorXd>(PyFloat_AsDouble(PyObject_GetAttrString($input, "x")), derivatives);
}

%typemap(out) Eigen::AutoDiffScalar<Eigen::VectorXd> {
  std::cout << "running AutoDiff output typemap" << std::endl;
  /* get sys.modules dict */
  PyObject* sys_mod_dict = PyImport_GetModuleDict();
  std::cout << "sys_mod_dict " << sys_mod_dict << std::endl;
  /* get the __main__ module object */
  PyObject* ad_mod = PyMapping_GetItemString(sys_mod_dict, "ad");
  std::cout << "ad_mod " << ad_mod << std::endl;
  /* call the class inside the __main__ module */
  $result = PyTuple_New(2);
  PyTuple_SetItem($result, 0, PyFloat_FromDouble($1.value()));
  PyObject* py_derivatives = PyTuple_New($1.derivatives().size());
  for (size_t i=0; i < $1.derivatives().size(); i++) {
    PyTuple_SetItem(py_derivatives, i, PyFloat_FromDouble($1.derivatives()(i)));
  }
  PyTuple_SetItem($result, 1, py_derivatives);
  // $result = PyObject_CallMethodObjArgs(ad_mod, PyString_FromString("adnumber"), , NULL);
  // std::cout << "found autodiff keys: " << _swig_wrapper_autodiff_keys << std::endl;
}

// %pythonprepend square(Eigen::AutoDiffScalar<Eigen::VectorXd>) %{
// print "in python, before square"
// _swig_wrapper_autodiff_keys = x.d().keys()
// _swig_wrapper_autodiff_keys.sort(key=lambda x: id(x))
// print "saving autodiff keys:", _swig_wrapper_autodiff_keys
// %}

%pythonappend square(Eigen::AutoDiffScalar<Eigen::VectorXd>) %{
print "in python, after square"
keys = args[0].d().keys()
print "looking up autodiff keys:", keys
temp_ad = ad.adnumber(val[0])
temp_ad._lc = dict(((key, val[1][i]) for i, key in enumerate(keys)))
val = temp_ad
%}

%pythoncode %{
import ad
%}

double square(double x);
Eigen::AutoDiffScalar<Eigen::VectorXd> square(Eigen::AutoDiffScalar<Eigen::VectorXd>);
Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1 > squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1>);

