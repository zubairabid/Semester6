import os
import csv
from tqdm import tqdm
import pprint
import pickle
import difflib
from wxconv import WXC

converter = WXC(order='utf2wx')

def get_anncorra(directory_path):
    marker_anncorra = {}
    anncorra_marker = {}

    print('Opening directory: ', directory_path)
    for filename in tqdm(os.listdir(directory_path)):
        filepath = os.path.join(directory_path, filename)

        with open(filepath, newline='') as csvfile:
            csvreader = csv.reader(csvfile, delimiter='\t')

            for row in csvreader:
                if not len(row) == 0:
                    marker = get_marker(row)
                    tag = get_tag(row)
                    increment_map(marker_anncorra, marker, tag)
                    increment_map(anncorra_marker, tag, marker)
    print('Got AnnCorra')

    return marker_anncorra, anncorra_marker

def get_ud(directory_path):
    marker_ud = {}
    ud_marker = {}

    for filename in (os.listdir(directory_path)):
        filepath = os.path.join(directory_path, filename)
        print('Opening file: ', filepath)

        with open(filepath) as datafile:
            for line in tqdm(datafile):
                row = line.split('\t')
                if len(row) > 4:
                    marker = get_marker(row)
                    tag = get_tag(row)
                    increment_map(marker_ud, marker, tag)
                    increment_map(ud_marker, tag, marker)

    print('Got UD')
    return marker_ud, ud_marker

def increment_map(dictionary, key, value):
    if key in dictionary.keys():
        temp = dictionary[key]
        if value in temp.keys():
            temp[value] += 1
        else:
            temp[value] = 1
    else:
        dictionary[key] = {}
        temp = dictionary[key]
        temp[value] = 1

def get_tag(row):
    return row[7]

def get_marker(row):
    word = row[1]
    base = row[2]
    
    word = converter.convert(word)
    base = converter.convert(base)

    marker = ''.join([s[-1] for s in difflib.ndiff(base, word) if s[0] == '+'])
    return marker

def render_latex(filename, dictionary, name):
    outfile = open(filename, 'w+')
    compiledstring = ''
    for key in dictionary.keys():
        output = ''
        for metric in dictionary[key].keys():
            output += key+' & '+metric+' & '+str(dictionary[key][metric])+'\\\\ \midrule '
        compiledstring += output + '\n'
    outfile.write(compiledstring)
    outfile.close()

def save(filename, dictionary):
    with open(filename, 'wb') as f:
        pickle.dump(dictionary, f)

def load(filename):
    with open(filname, 'rb') as f:
        ret = pickle.load(f)
    return ret

anncorra_marker = load('./ann_m.pkl')
ud_marker = load('./ud_m.pkl')
marker_anncorra = load('./m_ann.pkl')
marker_ud = load('./m_ud.pkl')


#marker_anncorra, anncorra_marker = get_anncorra('./AnnCorra/Training/')
#marker_ud, ud_marker = get_ud('./UD/Training/')

#pprint.pprint(marker_ud)

#render_latex('marker_ud_hindi', marker_ud, 'marker')
#render_latex('marker_anncorra_hindi', marker_anncorra, 'marker')
#render_latex('ud_marker_hindi', ud_marker, 'tag')
#render_latex('anncorra_marker_hindi', anncorra_marker, 'tag')

#save('m_ud.pkl', marker_ud)
#save('m_ann.pkl', marker_anncorra)
#save('ud_m.pkl', ud_marker)
#save('ann_m.pkl', anncorra_marker)

