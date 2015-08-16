from inverter_wrapper import Inverter
from inverter_wrapper import templatedInverse_d as templatedInverse
import numpy as np

def Inverter_getInversePlus1(self, M):
    inv = self.getInverse(M)
    return inv + np.ones(M.shape)
setattr(Inverter, "getInversePlus1", Inverter_getInversePlus1)
