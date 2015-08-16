#include "inverter.hpp"
#include <Eigen/LU>

Eigen::MatrixXd Inverter::getInverse(const Eigen::MatrixXd &M) {
  return M.inverse();
}

std::vector<Eigen::MatrixXd> Inverter::getInverseList(std::vector<Eigen::MatrixXd> matrices) {
  std::vector<Eigen::MatrixXd> result;
  result.reserve(matrices.size());
  for (std::vector<Eigen::MatrixXd>::iterator mat = matrices.begin(); mat != matrices.end(); ++mat) {
    result.push_back(mat->inverse());
  }
  return result;
}
