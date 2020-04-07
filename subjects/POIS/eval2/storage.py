from util import strencode, strdecode
import random

from numpy.polynomial.polynomial import Polynomial
from numpy.polynomial.polynomial import polyval, polyfit

from generate import generate
from sign import sign
from verify import verify

class SecureStorage:

    def __init__(self, k, e):
        self.k = k
        self.e = e

        self.bitlen = 50
        self.generator, self.prime = generate(self.bitlen)
        self.pri_key = random.randint(1,self.prime-1)
        self.pub_key = pow(self.generator, self.pri_key, self.prime)


    def encode(self, message):
        poly_coeffs = strencode(message, self.k)

        polynomial = Polynomial(poly_coeffs)

        shares = [(x, int(polyval(x, polynomial.coef))) for x in range(1, (self.k+self.e+1))]
        
        signed_shares = [(i, sign(str(i[1]), self.pri_key, self.bitlen, self.generator, self.prime)) for i in shares]

        return signed_shares

    def decode(self, m_part):

        m_ver = []
        for i in m_part:
            if verify(str(i[0][1]), i[1][0], i[1][1], i[1][2], self.bitlen, self.generator, self.prime, self.pub_key):
                m_ver.append(i[0])
            else:
                print("removing from consideration:")

        x = [i for i,j in m_ver]
        y = [j for i,j in m_ver]

        bits = [round(i) for i in polyfit(x, y, self.k-1)]
        print(bits)
        return strdecode(bits)



