import os
import pickle

def isusable(linearray):
    if len(linearray) == 0:
        return 'none'
    string = linearray[0]
    if string.isdigit():
        return 'phrase'
    else:
        try:
            float(string)
            return 'word'
        except ValueError:
            return 'none'

def getdrel(linearray):
    flag = False
    drel = ''
    for component in linearray:
        if 'drel' in component:
            flag = True
            try:
                drel = component.split('drel=\'')[1].split(':')[0]
                if '>' in drel:
                    drel = drel[:-3]
            except:
                print("Error?")
                drel = 'error'
                print(component, component.split('drel=\''))

    if not flag:
        drel = 'root'

    return drel

def getword(linearray):
    return linearray[1]

def anncorra_to_ud(allcombos):
    '''
    takes as input list from filestolist
    returns modified list with ud mappings
    '''
    internaldict = {}
    with open('Bengali/Documents/anncorraudmapping.txt', 'r') as f:
        for line in f:
            if ':' in line:
                internaldict[line.split(':')[0]] = line.split(':')[1].strip()

    print(internaldict)
    print("Using dictionary created above to convert to UD")
    newcombos = []
    for each in allcombos:
        if len(each[1]) == 0:
            continue
        try:
            udrel = internaldict[each[1]]
            newcombos.append((each[0], each[1], udrel))
        except:
            print("error on ", each)
    return newcombos



def filestolist(directory_path):
    '''
    Takes the SSF formatted files and parses them
    returns a dictionary of all words/chunks with associated tag
    '''
    allcombos = []
    words = []
    drel = ''
    for filename in os.listdir(directory_path):
        filepath = os.path.join(directory_path, filename)
        with open(filepath, 'r') as fil:
            print('opening ', filepath)
            for line in fil:
                linearray = line.split('\t')
                if isusable(linearray) == 'phrase':
                    allcombos.append((words, drel))
                    words = []

                    drel = getdrel(linearray)
                elif isusable(linearray) == 'word':
                    words.append(getword(linearray))
                    
    return allcombos

