perl ssf2morph.pl >morphinput
./moh_red.sh <morphinput >morphoutput 
perl morph2ssf.pl morphoutput >morph.rout
rm morphinput morphoutput 
