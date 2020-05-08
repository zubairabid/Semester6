import numpy as np
import math

def corrupt(m_enc, e):
    return m_enc[0:len(m_enc)-e]

def strencode(text, k):
#    print('#'*20,' encoding text ', '#'*20)

    # Padding with spaces
    textlen = len(text)
    leftover = k - textlen%k
    text = leftover*'|'+text
    piece = int(len(text) / k)

#    print('padded: ', text)

    encoded = np.zeros(k)
    for i in range(k):
        tx = ''
        l = i*piece
        u = (i+1)*piece
        for char in text[i*piece:(i+1)*piece]:
            print(char, end='')
            n = ord(char)
            dig = math.floor(math.log10(n)+1)
            tx += (3-dig)*'0'+str(n)

#        print(' encoded: ', tx)
        encoded[i] = int(tx, 10)

#    print('#'*20, ' encoding done ', '#'*20)

    return encoded

def strdecode(bits):
    '''
    return String version of whatever was encoded
    '''
    decoded = ''
#    print('#'*20,' decoding text ', '#'*20)
    for binary in bits:
        binary = str(int(binary))
        binlen = len(binary)
        leftover = 3-binlen%3
        if leftover == 3:
            leftover = 0
        binary = leftover*'0'+binary
        binlen = len(binary)
#        print("\npadded binary", binary, ' evaluates to ', end='')
        
        for i in range(int(binlen/3)):
            l = 3*i
            u = 3*(i+1)
            decoded += chr(int(binary[l:u]))
            print(chr(int(binary[l:u])), end='')

#    print('#'*20,' done decoding text ', '#'*20)
    
    return decoded
    
