#include <exception>
#include <vector>
#include <Eigen/Core>

class Inverter {
public:
  Inverter() {}

  Eigen::MatrixXd getInverse(const Eigen::MatrixXd &M);

  std::vector<Eigen::MatrixXd> getInverseList(std::vector<Eigen::MatrixXd> matrices);
};

