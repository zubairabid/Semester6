import random
from generate import generate
from hash import hash
from sign import sign
from verify import verify

from util import dict_to_binary
from util import dict_to_text

def demonstration():

    length = 50
    generator, prime = generate(length)
    pri_key = random.randint(1, prime-1)
    pub_key = pow(generator, pri_key, prime)

#message = "test"
#
#z, c, t = sign(message, pri_key, length, generator, prime)
#print(verify(message, z, c, t, length, generator, prime, pub_key))
#print(verify("notest", z, c, t, length, generator, prime, pub_key))

    print("Demonstrating three data structure variations on linked lists")
    print("For this demonstration, the following variables are set:")
    print("bitlength (prime): ", 50, 
            "\ngenerator: ", generator,
            "\nprivate key: ", pri_key,
            "\npublic key: ", pub_key)
    print('-'*100, '\n')
    print('Regular linked list: Constructing a list with data [1, 2, 3]')
    ll = List()
    ll.append(1)
    ll.append(2)
    ll.append(3)
    print("linked list head: ", ll.get())
    print("linked list head~1: ", ll.previous(ll.get()))

    print('-'*100, '\n')
    
    print('Hashed linked list: Constructing a list with data [1, 2, 3]')
    ll = HashList(generator, prime, length)
    ll.append(1)
    ll.append(2)
    ll.append(3)
    print("hash linked list head (note the hash): ", ll.get())
    print("hash linked list head~1: ", ll.previous(ll.get()))

    print('-'*100, '\n')

    print('Hash and signed linked list: Constructing a list with data [1, 2, 3]')
    ll = SignHashList(pri_key, generator, prime, length) 
    ll.append(1)
    ll.append(2)
    ll.append(3)
    print("hash and sign linked list head (note the sign and hash): ", ll.get())
    print("hash and sign linked list head~1: ", ll.previous(ll.get()))

    print('-'*100, '\n')


class List:
    def __init__(self):
        self.empty = True
        self.data = {}
        self.head = None

    def append(self, node):
        
        new_head = 1
        if self.empty:
            self.empty = False
        else:
            new_head = self.head + 1
        
        self.data[new_head] = {} 
        self.data[new_head]['pointer'] = self.head
        self.data[new_head]['node'] = node
        
        self.head = new_head

    def get(self):
        if not self.empty:
            return self.data[self.head]
        else:
            return None

    def previous(self, node):
        return self.data[node['pointer']]

class HashList:
    def __init__(self, generator, prime, length):
        self.empty = True
        self.data = {}
        self.head = None

        self.generator = generator
        self.prime = prime
        self.length = length

    def append(self, node):
        
        new_head = 1
        if self.empty:
            self.empty = False
        else:
            new_head = self.head + 1
        
        self.data[new_head] = {}
        self.data[new_head]['pointer'] = self.head
        self.data[new_head]['node'] = node

        if new_head == 1:
            self.data[new_head]['hash'] = None
        else:
            self.data[new_head]['hash'] = hash(
                    int(dict_to_binary(self.data[self.head])),
                    self.generator,
                    self.prime,
                    self.length
                    ) 
        
        self.head = new_head

    def get(self):
        if not self.empty:
            return self.data[self.head]
        else:
            return None

    def previous(self, node):
        return self.data[node['pointer']]




class SignHashList:
    def __init__(self, pri_key, generator, prime, length):
        self.empty = True
        self.data = {}
        self.head = None

        self.generator = generator
        self.prime = prime
        self.length = length
        self.pri_key = pri_key

    def append(self, node):
        
        new_head = 1
        if self.empty:
            self.empty = False
        else:
            new_head = self.head + 1
        
        self.data[new_head] = {}
        self.data[new_head]['pointer'] = self.head
        self.data[new_head]['node'] = node

        if new_head == 1:
            self.data[new_head]['hash'] = None
        else:
            self.data[new_head]['hash'] = hash(
                    int(dict_to_binary(self.data[self.head])),
                    self.generator,
                    self.prime,
                    self.length
                    ) 

        node_to_sign = dict_to_text(self.data[new_head])
        z, c, t = sign(node_to_sign,
                self.pri_key,
                self.length,
                self.generator,
                self.prime)
        self.data[new_head]['sign'] = (z, c, t)
        
        self.head = new_head

    def get(self):
        if not self.empty:
            return self.data[self.head]
        else:
            return None

    def previous(self, node):
        return self.data[node['pointer']]
