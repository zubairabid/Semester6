import requests 
from bs4 import BeautifulSoup as bs

with open('./corpus_20171076.txt', 'r') as corpus:
    for line in corpus:
        print(line)
        payload = {'notation':'utf', 'out_notation':'utf','input':line}

        response = requests.post(
            url='http://ltrc.iiit.ac.in/analyzer/bengali/run.cgi',
            data=payload,
            headers={'content-type':'application/x-www-form-urlencoded'}
        )
        response = requests.get(url='http://ltrc.iiit.ac.in/analyzer/bengali/all_out')
        output = response.text

        page = requests.get(url='http://ltrc.iiit.ac.in/analyzer/bengali/run.cgi')
        soup = bs(page.content, 'html.parser')

        i = 1
        accept = False
        flip = 0
        full = ""
        line = ""
        for tag in soup.find_all('td'):
#    print("looking at tag " + str(tag))
            if 'width' in str(tag) and tag['width'] == "5":
                if '.' in tag.text:
                    accept = True
                    line += str(i) + "\t"
            if accept:
                if 'align' in str(tag) and tag["align"] == "left":
                    if flip == 0:
                        flip = 1
                        line += str(tag.text) + "\t"
                        continue
                    if flip == 1:
                        flip = 0
                        accept = False
                        i += 1
                        line += str(tag.text) + "\t"
                        full += line + "\n"
#                print(line)
                        line = ""
                if 'align' in str(tag) and tag["align"] == "center":
                    line += str(tag.text) + "\t"

        full += "\n"

        with open('./corpus_20171076_morphed.txt', 'a+') as writeto:
            writeto.write(full)
        print(full)


