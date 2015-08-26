#include <exception>
#include <vector>
#include <Eigen/Core>
#include <Eigen/LU>

class Inverter {
public:
  Inverter() {}

  Eigen::MatrixXd getInverse(const Eigen::MatrixXd &M);
  Eigen::MatrixXd getInverse(const Eigen::MatrixXd &M, double offset);
  Eigen::MatrixXd getInverseRef(const Eigen::Ref<const Eigen::MatrixXd> & M);

  std::vector<Eigen::MatrixXd > getInverseList(std::vector<Eigen::MatrixXd > matrices);
};

template<typename Derived> 
Eigen::Matrix<Derived, Eigen::Dynamic, Eigen::Dynamic> templatedInverse(const Eigen::Matrix<Derived, Eigen::Dynamic, Eigen::Dynamic> &M) {
  return M.inverse();
} 