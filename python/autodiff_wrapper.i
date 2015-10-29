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
%eigen_typemaps(Eigen::Matrix<double, Eigen::Dynamic, 1>)
%eigen_typemaps(Eigen::MatrixXd)
%eigen_typemaps(Eigen::Matrix<double, Eigen::Dynamic, Eigen::Dynamic>)

%import <Eigen/Core>
%import <unsupported/Eigen/src/AutoDiff>


%inline %{

template <typename DerType, int RowsAtCompileTime, int ColsAtCompileTime>
class AutoDiffWrapper: public Eigen::Matrix<Eigen::AutoDiffScalar<DerType>, RowsAtCompileTime, ColsAtCompileTime> {

  typedef Eigen::Matrix<Eigen::AutoDiffScalar<DerType>, RowsAtCompileTime, ColsAtCompileTime> BaseMatrix;

public:
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>() {}

  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>(const Eigen::Matrix<Eigen::AutoDiffScalar<DerType>, RowsAtCompileTime, ColsAtCompileTime>& x): Eigen::Matrix<Eigen::AutoDiffScalar<DerType>, RowsAtCompileTime, ColsAtCompileTime>(x) {};

  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>(const Eigen::Matrix<double, RowsAtCompileTime, ColsAtCompileTime> &value, const Eigen::MatrixXd &derivatives) {
    this->resize(value.rows(), value.cols());
    if (derivatives.rows() != value.size()) {
      throw std::runtime_error("derivatives must have one row for every element in value");
    }
    for (size_t i=0; i < value.rows(); i++) {
      for (size_t j=0; j < value.cols(); j++) {
        this->coeffRef(i, j) = Eigen::AutoDiffScalar<Eigen::VectorXd>(value(i,j), derivatives.row(i + value.rows() * j));
      }
    }
  }

  Eigen::Matrix<double, RowsAtCompileTime, ColsAtCompileTime> value() {
    Eigen::Matrix<double, RowsAtCompileTime, ColsAtCompileTime> result(this->rows(), this->cols());
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
  }

  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator+ (const AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>& other) {
    return BaseMatrix::operator+(other).eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator- (const AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>& other) {
    return BaseMatrix::operator-(other).eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> arrayMultiply (const AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>& other) {
    return this->array().operator*(other.array()).matrix().eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> arrayDivide (const AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime>& other) {
    return this->array().operator/(other.array()).matrix().eval();
  }

  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator+ (double other) {
    return this->array().operator+(other).matrix().eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator- (double other) {
    return this->array().operator-(other).matrix().eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator* (double other) {
    return BaseMatrix::operator*(other).eval();
  }
  AutoDiffWrapper<DerType, RowsAtCompileTime, ColsAtCompileTime> operator/ (double other) {
    return BaseMatrix::operator/(other).eval();
  }
};

%}

%template(AutoDiffVectorDynamic) AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1>;
%template(AutoDiffMatrixDynamic) AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, Eigen::Dynamic>;

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

AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1> squareVector(AutoDiffWrapper<Eigen::VectorXd, Eigen::Dynamic, 1>);
// Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, Eigen::Dynamic> x);
// Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> squareVector(Eigen::Matrix<Eigen::AutoDiffScalar<Eigen::VectorXd>, Eigen::Dynamic, 1> x);

