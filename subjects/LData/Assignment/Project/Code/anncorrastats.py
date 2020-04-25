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

mapping = {
        "ccof":"cc",
        "dislocated":"fragof",
        "jk1":"nmod",
        "k1u":"nmod",
        "k2g":"acl",
        "nmod":"k2p",
        "k2s":"acl",
        "k2u":"nmod",
        "k3":"nmod",
        "k3u":"nmod",
        "k4":"iobj",
        "k4u":"nmod",
        "k5":"nmod",
        "k7":"nmod",
        "k7a":"nmod",
        "k7p":"nmod",
        "k7pu":"nmod",
        "k7t":"nmod",
        "k7tu":"nmod",
        "k7u":"nmod",
        "main":"root",
        "mk1":"dobj",
        "nmod__k1inv":"acl",
        "nmod__k2inv":"acl",
        "nmod__neg":"neg",
        "nmod__pofinv":"compound",
        "nmod__relc":"acl",
        "pof":"compound",
        "pof__inv":"compound",
        "r6":"nmod",
        "r6-k1":"nmod",
        "r6-k2":"nmod",
        "r6v":"nmod",
        "ras-k1":"nmod",
        "ras-k1u":"nmod",
        "ras-k2":"nmod",
        "ras-k4":"nmod",
        "ras-k4a":"nmod",
        "ras_k7":"nmod",
        "ras__k7":"nmod",
        "ras-k7":"nmod",
        "ras-k7p":"nmod",
        "ras-neg":"nmod",
        "ras-pof":"nmod",
        "ras-r6":"nmod",
        "ras-r6-k2":"nmod",
        "ras-rt":"nmod",
        "rbmod":"advmod",
        "rsym":"punct",
        "rbmod__relc":"acl",
        "undef":"dep",
        "enm":"dep",
        "rad":"vocative",
        "rd":"nmod",
        "rsp":"nmod",
        "nmod__emph":"nmod",
        "lwg__intf":"advmod",
        "lwg__rp":"dep",
        "vmod__adv":"advmod",
        "pof__cn":"compound",
        "pof__redup":"compound",
        "lwg__nst":"case",
        "jjmod__intf":"advmod",
        "lwg__neg":"neg",
        "lwg__psp":"case",
        "lwg__rdp":"compound",
        "lwg__unk":"dep",
        "lwg__vm":"compound",
        "psp__cl":"case",
        "mod__wq":"det",
        "jjmod":"advmod",
        "k1s #type=xcomp":"dobj",
        "nmod__adj #type=DET":"amod",
        "nmod #type=JJ":"amod",
        "adv #type=RB":"advmod",
        "vmod #type=fclause":"parataxis",
        "k2 #type=fclause":"dobj",
        "k2 #type=fclause":"ccomp",
        "k2 #type=nclause":"xcomp",
        "rs #type=fclause":"acl",
        "lwg__vaux #type=VAUX":"aux",
        "lwg__vaux_cont #type=VAUX":"aux",
        "lwg__vaux #type=VAUX":"auxpass",
        "lwg__vaux_cont #type=VAUX":"auxpass",
        "k1 #type=voice":"nsubj",
        "k1 #type=voice":"nsubjpass",
        "k4a #type=voice":"nsubj",
        "pk1 #type=voice":"nsubj",
        "rh #type=clause":"advcl",
        "rt #type=clause":"advcl",
        "rtu #type=clause":"advcl",
        "sent-adv #type=clause":"advcl",
        "vmod #type=clause":"advcl",
        }
