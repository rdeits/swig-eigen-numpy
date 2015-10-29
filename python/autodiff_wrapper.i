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

%eigen_typemaps(Eigen::VectorXd)
%eigen_typemaps(Eigen::MatrixXd)

%import <Eigen/Core>
%import <unsupported/Eigen/src/AutoDiff>


%inline %{

class AutoDiffVectorDynamic: public Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> {

public:
  AutoDiffVectorDynamic() {}

  AutoDiffVectorDynamic(const Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1>& x): Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1>(x) {};

  AutoDiffVectorDynamic(Eigen::VectorXd value, Eigen::MatrixXd derivatives) {
    this->resize(value.rows(), value.cols());
    for (size_t i=0; i < value.size(); i++) {
      this->coeffRef(i) = Eigen::AutoDiffScalar<Eigen::VectorXd>(value(i), derivatives.row(i));
      std::cout << "setting derivatives for index: " << i << " to: " << derivatives.row(i) << std::endl;
    }
    // Eigen::VectorXd der_vector(derivatives.cols());
    // der_vector(0) = derivatives;
    // this->coeffRef(0) = Eigen::AutoDiffScalar<Eigen::VectorXd>(value, der_vector);
  }

  Eigen::VectorXd value() {
    Eigen::VectorXd result(this->size());
    for (size_t i=0; i < this->size(); i++) {
      result(i) = this->coeffRef(i).value();
    }
    return result;
  }

  Eigen::MatrixXd derivatives() {
    Eigen::MatrixXd result(this->size(), this->size() > 0 ? this->coeffRef(0).derivatives().size() : 0);
    for (int i=0; i < this->size(); i++) {
      if (this->coeffRef(i).derivatives().size() > result.cols()) {
        result.conservativeResize(result.rows(), this->coeffRef(i).derivatives().size());
      }
      for (int j=0; j < this->coeffRef(i).derivatives().size(); j++) {
        result(i, j) = this->coeffRef(i).derivatives()(j);
      }
    }
    return result;

    // return this->coeffRef(0).derivatives()(0);
  }
};
%}

// %inline %{
// class AutoDiffVectorDynamic {
// private:
//   Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> wrapped;

// public:
//   AutoDiffVectorDynamic(): wrapped(0,0) {}

//   AutoDiffVectorDynamic(double value, double derivatives) {
//     wrapped.resize(1,1);
//     Eigen::VectorXd der_vector(1);
//     der_vector(0) = derivatives;
//     wrapped(0) = Eigen::AutoDiffScalar<Eigen::VectorXd>(value, der_vector);
//   }

//   AutoDiffVectorDynamic(const Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> &_wrapped): wrapped(_wrapped) {};

//   AutoDiffVectorDynamic& operator= (const Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> &_wrapped) {
//     wrapped = _wrapped;
//     return *this;
//   }

//   operator Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic>() { return wrapped;}

//   void resize(size_t m, size_t n) {
//     wrapped.resize(m, n);
//   }

//   double value() {
//     return this->wrapped(0).value();
//   }

// };
// %}

// %include <autodiff.i>

// %autodiff_typemaps(2200, 1, Eigen::VectorXd)
// %autodiff_typemaps(2201, Eigen::Dynamic, Eigen::VectorXd)

%include "square.hpp"
// %rename(squareVector) squareVector<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic>;

AutoDiffVectorDynamic squareVector(AutoDiffVectorDynamic);
// Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> x);
// Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> x);

