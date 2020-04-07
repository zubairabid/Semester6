from storage import SecureStorage
from util import corrupt

K = int(input("Enter value of k: ")) 
E = int(input("Enter maximum redundance (value of e): "))

message = input("Enter your message here: ")
length = len(message)

storage = SecureStorage(k=K, e=E)

print("\nGenerating message shares now")
m_enc = storage.encode(message)

print("Generated shares: ", m_enc)

print("\nCorrupting {0} random blocks of encoded message".format(E))
m_corr = corrupt(m_enc, e=E)
print("Corrupted message", m_corr)

print("\nDecoding message now")
m_dec = storage.decode(m_corr)

print("Final decoded message: ", m_dec[::-1][:length][::-1])
