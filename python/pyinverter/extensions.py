# This file demonstrates one way to add python-only methods to a wrapped C++ class. We define a new class called InverterExtension, which contains the python methods we would like to add. Then in inverter_wrapper.i we add the following python code:
#
#   %pythoncode %{
#   import extensions
#   Inverter.__bases__+= (extensions.InverterExtension,)
#   %}
#
# which makes InverterExtension a parent of Inverter, and thus lets us call the (trivial) getInversePlus1 method on any Inverter.

import numpy as np

class InverterExtension:
    def getInversePlus1(self, M):
        """
        Invert the matrix and add one to every element
        """
        inv = self.getInverse(M)
        return inv + np.ones(M.shape)
