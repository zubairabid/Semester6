import pickle
from anncorrastats import anncorra_to_ud
from anncorrastats import filestolist

anntag = filestolist('Bengali/Data/Training')
with open('./anncorra.pkl', 'wb') as f:
    pickle.dump(anntag, f)

with open('./anncorra.pkl', 'rb') as f:
    anntag = pickle.load(f)

udanntag = anncorra_to_ud(anntag)
with open('./udanncorra.pkl', 'wb') as f:
    pickle.dump(udanntag, f)
#print(newlist)
