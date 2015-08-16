import pyinverter
import numpy as np

inv = pyinverter.Inverter()
m = np.array([[2.0, 0.0],
              [0.0, 2.0]])
print inv.getInverse(m)
print inv.getInversePlus1(m)

try:
    inv.getInverse("foo")
except Exception as e:
    if e.message == "The given input is not known as a NumPy array or matrix.":
        print "(successfully threw the expected error)"
    else:
        raise e

print inv.getInverseList([np.eye(2), np.eye(3)])

print pyinverter.templatedInverse(np.eye(2))
