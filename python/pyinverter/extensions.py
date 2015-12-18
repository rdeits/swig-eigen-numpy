# This file demonstrates one way to add python-only methods to a wrapped C++ class. We define a new method called Inverter_getInversePlus1. Then in inverter_wrapper.i we add the following python code:
#
# %pythoncode %{
# from .extensions import Inverter_getInversePlus1
# Inverter.getInversePlus1 = Inverter_getInversePlus1
# %}
#
# which makes getInversePlus1 a method of Inverter implemented by the function
# defined below.

import numpy as np

def Inverter_getInversePlus1(self, M):
    """
    Invert the matrix and add one to every element
    """
    inv = self.getInverse(M)
    return inv + np.ones(M.shape)
