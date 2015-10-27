from ad import adnumber
import pyad.autodiff
import numpy as np
from taylor import TaylorVar

t = TaylorVar(np.array([[1,2,3]]).T)
t2 = pyad.autodiff.squareVector(t)
print t2
print t2.value
print t2.derivatives



y = 2.0
dydt = 3.0
t = adnumber(y / dydt)
y = t * dydt
print y.x, y.d(t)
t3 = TaylorVar.from_adnumber(y, [t])
t4 = pyad.autodiff.squareVector(t3)
print t4.value, t4.derivatives

y2 = t4.to_adnumber([t])
print y2[0].x
print y2[0].d(t)

y3 = adnumber(np.array([1,2,3]))
t5 = TaylorVar.from_adnumber(y3, y3)
t6 = pyad.autodiff.squareVector(t5)
y4 = t6.to_adnumber(y3)
print y4[1].d(y3[1])

t = TaylorVar(np.array([1,2,3]))
t2 = pyad.autodiff.squareVector(t)
print t
print t2

# x = 2 * y
# x2 = pyad.autodiff.square(x)
# print x2
# print x2.d(y)