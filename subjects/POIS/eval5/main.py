from storage import SecureStorage
from util import corrupt
from random import randint
import time

def send(message):
    print("\nSplitting message across channels")
    m_enc = storage.encode(message)

    print("Messages across channels: ", m_enc)

    print("\nCorrupting {0} random channels".format(E))
    m_corr = corrupt(m_enc, e=E)
    print("Corrupted message", m_corr)

    print("\nDecoding message now")
    m_dec = storage.decode(m_corr)

    print("Final decoded message: ", m_dec[::-1][:length][::-1])
    return m_dec[::-1][:length][::-1]

def encrypt(value):
    return (value+1)%10

def decrypt(value):
    return (value-1)%10

def xor(num, char):
    print('xorring',num,'and',char)
    return chr(num^ord(char))

print("Setting up fault tolerant channel")
K = int(input("Enter value of k: ")) 
E = int(input("Enter maximum redundance (value of e): "))

message = input("B array storage: ")
query = int(input("A requesting index: "))
length = len(message)
time.sleep(1)

storage = SecureStorage(k=K, e=E)

key = 0
sendstr = ''
for i in range(length):
    random = randint(0,9)
    if i == query:
        key = random
        random = encrypt(random)
    sendstr += str(random)

print("A Generated random string: ",sendstr)
print("Value of i only A knows: ",key)
print("A sending message to B")
time.sleep(2)
bgets = send(sendstr)
print("After fault-tolerant routing, B recovers: ",bgets)
print("Decrypting what was received, B:")
time.sleep(2)
newsend=''
for i in range(length):
    val = decrypt(int(bgets[i]))
    newchar = xor(val, message[i])
    newsend += newchar
print("Decrypted:",newsend)
print("B sending message to A")
time.sleep(2)
agets = send(newsend)
print("After fault-tolerant routing, A recovers: ",agets)
print("Decrypting what was received, A:")
recovered = xor(key, agets[int(query)])
print(recovered)














