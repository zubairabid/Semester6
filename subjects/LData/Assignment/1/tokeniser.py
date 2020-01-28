vocabulary = []

with open('./corpus_20171076.txt', 'r') as corpus:
    for line in corpus:
        # print(line)
        for word in line.split(' '):
            if word not in vocabulary:
                vocabulary.append(word)

# print(vocabulary)
with open('./vocabulary.csv', 'w+') as output:
    for token_id, token in enumerate(vocabulary):
        output.write(str(token_id)+","+str(token)+"\n")
