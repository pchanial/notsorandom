from __future__ import division
import numpy as np
import operator
import os
import pyfits

from .config import NOISEDIR

__all__ = ['normal', 'uniform']

def generate_random(maxsize=2**16):
    data = np.random.normal(size=maxsize)
    pyfits.writeto('randomn.fits', data)
    data = np.random.uniform(size=maxsize)
    pyfits.writeto('randomu.fits', data)

class NotSoRandom(object):
    def __init__(self):
        self._data = pyfits.open(os.path.join(NOISEDIR, self.FILE))[0].data
        self._maxsize = self._data.size
        self._p = 0

    def __call__(self, shape):
        if shape is None:
            shape = ()
        elif not isinstance(shape, (list, tuple)):
            shape = (shape,)

        n = reduce(operator.mul, shape, 1)
        output = np.empty(shape)
        if n == 0:
            return output
        output_ = output.ravel()

        # copy data in chunks of maxsize
        for k in range(int(np.ceil(n / self._maxsize))):
            a = k * self._maxsize
            z = min((k + 1) * self._maxsize, n)
            avail = min(self._maxsize - self._p, z - a)
            output_[a:a+avail] = self._data[self._p:self._p+avail]
            self._p += avail
            if avail < z - a:
                output_[a+avail:z] = self._data[:z-a-avail]
                self._p = z - a - avail

        return output

class NotSoNormal(NotSoRandom):
    FILE = 'randomn.fits'
    def __call__(self, loc=0., scale=1., size=None):
        output = NotSoRandom.__call__(self, size)
        output *= scale
        output += loc
        return output

class NotSoUniform(NotSoRandom):
    FILE = 'randomu.fits'
    def __call__(self, low=0., high=1., size=None):
        output = NotSoRandom.__call__(self, size)
        output *= high - low
        output += low
        return output

normal = NotSoNormal()
uniform = NotSoUniform()
