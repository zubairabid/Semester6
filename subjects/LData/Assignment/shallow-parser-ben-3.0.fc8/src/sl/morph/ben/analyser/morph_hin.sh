perl ssf2morph.pl oldinput>morphinput
./moh.sh   
perl morph2ssf.pl morphoutput >morph.rout
rm morphinput morphoutput 
