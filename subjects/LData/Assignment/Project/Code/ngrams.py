import os
import csv
import pickle
import pprint
from tqdm import tqdm

def render_latex(filename, dictionary):
    sortedlist = [(k,v) for k, v in sorted(anndict2.items(), key=lambda item: item[1], reverse=True)]
    outfile = open(filename, 'w+')
    compiledstring = ''
    for (k,v) in sortedlist:
        output = str(k)+' & '+str(v)+' \\\\ \midrule'
        compiledstring += output + '\n'
    outfile.write(compiledstring)
    outfile.close()

def load_anncorra(directory_path):
    listoftags = []
    print('Opening directory: ', directory_path)
    for filename in tqdm(os.listdir(directory_path)):
        filepath = os.path.join(directory_path, filename)
        with open(filepath, newline='') as csvfile:
            csvreader = csv.reader(csvfile, delimiter='\t')
            for row in csvreader:
                if len(row) > 1:
                    listoftags.append(get_tag(row))

    return listoftags

def load_ud(directory_path):
    listoftags = []
    print('Opening directory: ', directory_path)
    for filename in (os.listdir(directory_path)):
        filepath = os.path.join(directory_path, filename)
        with open(filepath, newline='') as csvfile:
            for line in csvfile:
                row = line.split('\t')
                if len(row) > 1:
                    listoftags.append(get_tag(row))

    return listoftags

def get_tag(row):
    return row[7]

def getstats(listoftags, n):
    counterdict = {}
    length = len(listoftags)
    for i in range(length-n+1):
        ngram = ''
        for j in range(i,i+n):
            ngram += listoftags[j]+' '
        increment_map(counterdict, ngram)
    return counterdict

def increment_map(dictionary, key):
    if key in dictionary.keys():
        dictionary[key] += 1
    else:
        dictionary[key] = 1

udstr = load_ud('./UD/Training')
annstr = load_anncorra('./AnnCorra/Training')

uddict2 = getstats(udstr, n=2)
uddict3 = getstats(udstr, n=3)
uddict4 = getstats(udstr, n=4)

anndict2 = getstats(annstr, n=2)
anndict3 = getstats(annstr, n=3)
anndict4 = getstats(annstr, n=4)

render_latex('ud2', uddict2)
render_latex('ud3', uddict3)
render_latex('ud4', uddict4)
render_latex('ann2', anndict2)
render_latex('ann3', anndict3)
render_latex('ann4', anndict4)

pprint.pprint(anndict2)
#pprint.pprint([(k,v) for k, v in sorted(anndict2.items(), key=lambda item: item[1], reverse=True)])
