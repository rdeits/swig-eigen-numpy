import ad
import numpy as np

class TaylorVar(object):
    __slots__ = ["value", "derivatives"]

    def __init__(self, value, derivatives=None):
        self.value = np.asarray(value)
        ndim = self.value.ndim
        if ndim < 2:
            self.value = self.value.reshape((self.value.size, 1))
        numel = self.value.size
        assert ndim < 3, "Our c++ methods can't handle values with dimension < 1 or > 3, so we don't support them in Python either"
        if derivatives is None:
            df = np.empty((numel,), dtype=np.object)
            for i in range(numel):
                df[i] = np.zeros((numel,))
                df[i][i] = 1.0
            df = df.reshape(self.value.shape, order='F')
            derivatives = [df]
        self.derivatives = derivatives

    def to_adnumber(self, derivative_variables):
        assert len(self.derivatives) == 1, "can only convert first derivatives to adnumber"
        assert len(derivative_variables) == len(self.derivatives[0].flat[0])
        adnum = ad.adnumber(np.asarray(self.value))
        for i, n in enumerate(adnum.flat):
            n._lc = dict(zip(derivative_variables, self.derivatives[0].flat[i]))
        return adnum

    @classmethod
    def from_adnumber(cls, adnum, derivative_variables):
        adnum = np.asarray(adnum, dtype=np.object)
        if adnum.ndim < 2:
            adnum = adnum.reshape((adnum.size, 1))
        value = np.empty(adnum.shape)
        derivatives = [np.empty(adnum.shape, dtype=np.object)]
        for (i, a) in enumerate(adnum.flat):
            value.flat[i] = a.x
            derivatives[0].flat[i] = np.array([a.d(v) for v in derivative_variables])

        return cls(value, derivatives)
