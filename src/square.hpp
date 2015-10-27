#include <Eigen/Core>
#include <unsupported/Eigen/AutoDiff>

template <typename Scalar, int ColsAtCompileTime>
Eigen::Matrix<Scalar, Eigen::Dynamic, ColsAtCompileTime> squareVector(Eigen::Matrix<Scalar, Eigen::Dynamic, ColsAtCompileTime> x) {
  return x.array() * x.array();
}
