from inverter_wrapper import Inverter
import numpy as np

def Inverter_getInversePlus1(self, M):
    inv = self.getInverse(M)
    return inv + np.ones(M.shape)
setattr(Inverter, "getInversePlus1", Inverter_getInversePlus1)
