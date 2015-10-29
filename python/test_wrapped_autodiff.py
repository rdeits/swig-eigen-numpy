import numpy as np

import pyad.autodiff

x = pyad.autodiff.AutoDiffVectorDynamic(np.array([1.0, 3.0]), np.array([2.0, 5.0]))
print x.value()
assert (x.value() == np.array([[1.0, 3.0]]).T).all()
assert (x.derivatives() == np.array([[2.0, 5.0]]).T).all()

y = pyad.autodiff.squareVector(x)
print y.value()
assert (y.value() == np.power(x.value(), 2)).all()
assert (y.derivatives() == x.derivatives() * 2 * x.value()).all()

z = x + y
print z.value()
assert (z.value() == x.value() + y.value()).all()
assert (z.derivatives() == x.derivatives() + y.derivatives()).all()

w = (((x + 1) - 5) * 2) / 1.5
print w.value()
assert (w.value() == (x.value() + 1 - 5) * 2 / 1.5).all()
assert np.allclose(w.derivatives(), x.derivatives() * 2 / 1.5)

q = x.arrayMultiply(x)
print q.value()
assert np.allclose(q.value(), y.value())
assert np.allclose(q.derivatives(), y.derivatives())