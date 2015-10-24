import pyad.autodiff
import numpy as np
from taylor import TaylorVar

t = TaylorVar(np.array([1,2,3]))
print t.derivatives[0][0].dtype
t2 = pyad.autodiff.squareVector(t)
print t2
print t2.value
print t2.derivatives
# y = adnumber(1.5)
# x = 2 * y
# x2 = pyad.autodiff.square(x)
# print x2
# print x2.d(y)