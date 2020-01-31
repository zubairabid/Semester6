import requests 

payload = {'notation':'utf','out_notation':'utf','input':'প্রতিদিন পুরোনো সাইকেল নিয়ে বের হন আদিত্য কুমার।'}

response = requests.post(
    url='http://ltrc.iiit.ac.in/analyzer/bengali/run.cgi',
    data=payload,
    headers={'content-type':'application/x-www-form-urlencoded'}
)
response = requests.get(url='http://ltrc.iiit.ac.in/analyzer/bengali/all_out')
output = response.text
print(output)
