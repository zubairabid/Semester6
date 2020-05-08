from hash import hash

def verify(message, z, c, t, length, generator, prime, pub_key):
#    print("Verifying the signature")
    m_binary = ''.join(format(ord(i), 'b') for i in message)
    if c == hash(int(bin(t)+m_binary,2), generator, prime, length):
        if (pow(pub_key, c, prime)*t)%prime == pow(generator, z, prime):
            return "Signs and message match"
        else:
            return "Signs are incorrect"
    else:
        return "Message is not the same"
