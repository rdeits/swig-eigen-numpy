#include "inverter.hpp"
#include <Eigen/LU>

Eigen::MatrixXd Inverter::getInverse(const Eigen::MatrixXd &M) {
  return M.inverse();
}