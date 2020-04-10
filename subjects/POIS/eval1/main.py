import random
from generate import generate
from sign import sign
from verify import verify

length = int(input("Enter number of bits: "))
generator, prime = generate(length)
print(generator, prime)

# Key generation
pri_key = random.randint(1,prime-1) #private key
print("Private Key =", pri_key)
pub_key = pow(generator,pri_key,prime) #public key
print("Public Key =", pub_key)

message = input("Enter message text: ")

z, c, t = sign(message, pri_key, length, generator, prime)
print(verify(message, z, c, t, length, generator, prime, pub_key)) 
