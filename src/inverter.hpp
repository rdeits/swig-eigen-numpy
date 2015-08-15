#include <Eigen/Core>

class Inverter {
public:
  Inverter() {}

  Eigen::MatrixXd getInverse(const Eigen::MatrixXd &M);
};

