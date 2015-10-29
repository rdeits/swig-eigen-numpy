#include <Eigen/Core>
#include <unsupported/Eigen/AutoDiff>

template <typename Scalar, int ColsAtCompileTime>
Eigen::Matrix<Scalar, Eigen::Dynamic, ColsAtCompileTime> squareMatrix(Eigen::Matrix<Scalar, Eigen::Dynamic, ColsAtCompileTime> x) {
  return x.array() * x.array();
}

template <typename Scalar>
Eigen::Matrix<Scalar, Eigen::Dynamic, 1> squareVector(Eigen::Matrix<Scalar, Eigen::Dynamic, 1> x) {
  return x.array() * x.array();
}
