#include <Eigen/Core>
#include <unsupported/Eigen/AutoDiff>

template <typename Scalar>
Eigen::Matrix<Scalar, Eigen::Dynamic, Eigen::Dynamic> squareVector(Eigen::Matrix<Scalar, Eigen::Dynamic, Eigen::Dynamic> x) {
  return x.array() * x.array();
}
