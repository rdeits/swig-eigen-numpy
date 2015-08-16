#include <iostream>
#include "inverter.hpp"

int main(int argc, char** argv) {
  Eigen::MatrixXd mat(2, 2);
  std::vector<Eigen::MatrixXd> matrices;
  mat << 1.0, 0.0,
         0.0, 2.0;
  matrices.push_back(mat);

  Inverter inv;
  std::cout << inv.getInverse(mat) << std::endl;

  std::vector<Eigen::MatrixXd> results = inv.getInverseList(matrices);
  std::cout << results[0] << std::endl;
}