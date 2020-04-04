import random
from math import log2, ceil 
import textwrap
from generate import generate

def hash(message, generator, prime, length):
    block_length = length 
    block_count = ceil(length/block_length)

    message = bin(message)
    leftover = block_length - (len(message)-2)%block_length
    message = leftover*"0" + message[2:]
    blocks = textwrap.wrap(message, block_length)

    z0 = prime-1
    for message_part in blocks:
        z0 = hash_baseline(generator, prime, block_length, z0, int(message_part, 2))

    return z0
    
def hash_baseline(generator, prime, length, x1, x2):
    random_h = (1<<length) - prime 
    return (pow(generator, x1, prime) * pow(random_h, x2, prime)) % prime
