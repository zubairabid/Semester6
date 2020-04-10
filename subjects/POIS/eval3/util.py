def text_to_binary(text):
    binary = ''.join(format(ord(i), 'b') for i in text)
    return binary

def dict_to_text(dictionary):
    string = ''.join(str(key)+str(val) for key, val in dictionary.items())
    return string


def dict_to_binary(dictionary):
    return text_to_binary(dict_to_text(dictionary))
