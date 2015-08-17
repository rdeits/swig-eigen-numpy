from __future__ import print_function
# This lets us use the python3-style print() function even in python2. It should have no effect if you're already running python3.

import pyinverter
import numpy as np

# Construct an instance of the Inverter class, which wraps the C++ class.
inv = pyinverter.Inverter()
m = np.array([[2.0, 0.0],
              [0.0, 2.0]])
# Call a C++ method with a Numpy array.
print(inv.getInverse(m))

# We defined getInversePlus1 in python in pyinverter/pyinverter.py. But we attached it to the Inverter class, so we can call it just like a C++ method:
print(inv.getInversePlus1(m))

# Calling a function without passing a numpy array should raise a helpful error:
try:
    inv.getInverse("foo")
except Exception as e:
    if str(e) == "The given input is not known as a NumPy array or matrix.":
        print("(successfully threw the expected error)")
    else:
        raise e

# In swig/eigen.i, we set up Python lists of numpy arrays to map to and from std::vectors of Eigen Matrices:
print(inv.getInverseList([np.eye(2), np.eye(3)]))

# templatedInverse is a templated function in C++, but we imported the explicit instantiation which acts on doubles:
print(pyinverter.templatedInverse(np.eye(2)))
