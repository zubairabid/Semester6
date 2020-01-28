perl $setu/bin/sys/common/printinput.pl $1 > morphinput1
perl $setu/bin/sys/common/deletesentencetag.pl < morphinput1 > morphinput2
perl $setu/bin/sys/common/convert.pl morphinput2 > morphinput3
$setu/bin/sl/morph/ben/morph.out --logfilepath morph.log --pdgmfilepath $setu/data_bin/sl/morph/ben/ --uwordpath $setu/data_bin/sl/morph/ben/dict_final --dictfilepath $setu/data_bin/sl/morph/ben/dict/  -ULDWH --inputfile morphinput3 --outputfile morphoutput
perl $setu/bin/sys/common/printinput.pl < morphoutput






