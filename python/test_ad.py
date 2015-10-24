import pyad.autodiff
from ad import adnumber
y = adnumber(1.5)
x = 2 * y
x2 = pyad.autodiff.square(x)
print x2
print x2.d(y)