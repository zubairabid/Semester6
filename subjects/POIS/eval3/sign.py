import random
from hash import hash

def sign(message, pri_key, length, generator, prime):
#    print("Signing the message")

    message_binary = ''.join(format(ord(i), 'b') for i in message)
    # Select random r, to generate a t with g^r mod p
    r = random.randint(1, prime-1)
    t = pow(generator, r, prime)

    # We will hash t|m to get c. z=cx+r after that
    binary = bin(t)+message_binary
#    print("Hashing ", binary, " to get our 'c'")
    c = hash(int(binary, 2), generator, prime, length)
    z = c*pri_key + r

#    print("Message signing done")
    return z, c, t
