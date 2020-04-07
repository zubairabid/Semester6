from util import strencode, strdecode

from numpy.polynomial.polynomial import Polynomial
from numpy.polynomial.polynomial import polyval, polyfit

class SecureStorage:

    def __init__(self, k, e):
        self.k = k
        self.e = e

    def encode(self, message):
        poly_coeffs = strencode(message, self.k)

        polynomial = Polynomial(poly_coeffs)

        return [(x, polyval(x, polynomial.coef)) for x in range(1, (self.k+self.e+1))]

    def decode(self, m_part):
        x = [i for i,j in m_part]
        y = [j for i,j in m_part]

        bits = [round(i) for i in polyfit(x, y, self.k-1)]
        print(bits)
        return strdecode(bits)



