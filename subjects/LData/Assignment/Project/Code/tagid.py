import pprint
import string
import pickle
from wxconv import WXC

converter = WXC(order='utf2wx', lang='ben')

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

def get_marker(words):
    # TODO work on
    marker = "-"
    if len(words) > 1:
        marker = words[-1]
        marker = converter.convert(marker)
    return marker

def trim(dictionary, cutoff=3):
    for key in dictionary.keys():
        newdict = {}
        olddict = dictionary[key]
        for subkey in olddict:
            if olddict[subkey] > cutoff:
                newdict[subkey] = olddict[subkey]
        if len(newdict) == 0:
            for subkey in olddict:
                newdict[subkey] = olddict[subkey]
        dictionary[key] = newdict

def render_latex_table(filename, dictionary):
    outfile = open(filename, 'w+')
    compiledstring = ''
    for key in dictionary.keys():
        output = ''
        for metric in dictionary[key].keys():
            if metric in string.punctuation:
                continue
            output += metric+' & '+key+' & '+str(dictionary[key][metric])+'\\\\ \midrule '
        compiledstring += output + '\n'
    outfile.write(compiledstring)
    outfile.close()

with open('udanncorra.pkl', 'rb') as tags:
    listofall = pickle.load(tags)

ud_marker = {}
anncorra_marker = {}
marker_ud = {}
marker_anncorra = {}

for combo in listofall:
    marker = get_marker(combo[0])
    anncorra = combo[1]
    ud = combo[2]

    increment_map(ud_marker, ud, marker)
    increment_map(anncorra_marker, anncorra, marker)
    increment_map(marker_anncorra, marker, anncorra)
    increment_map(marker_ud, marker, ud)

trim(ud_marker)
trim(anncorra_marker)
trim(marker_ud)
trim(marker_anncorra)

render_latex_table('ud_marker', ud_marker)
render_latex_table('anncorra_marker', anncorra_marker)
render_latex_table('marker_anncorra', marker_anncorra)
render_latex_table('marker_ud', marker_ud)

