from hash import hash

def verify(message, z, c, t, length, generator, prime, pub_key):
    print("Verifying the signature")
    m_binary = ''.join(format(ord(i), 'b') for i in message)
    if c == hash(int(bin(t)+m_binary,2), generator, prime, length):
        if (pow(pub_key, c, prime)*t)%prime == pow(generator, z, prime):
            return True 
        else:
            return False
    else:
        return False
