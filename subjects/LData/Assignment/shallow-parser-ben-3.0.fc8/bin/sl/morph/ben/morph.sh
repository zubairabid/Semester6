perl $SHALLOW_PARSER_BEN/bin/sys/common/deletesentencetag.pl $1 > morphinput$$
$SHALLOW_PARSER_BEN/bin/sl/morph/ben/morph.out --logfilepath morph.log --pdgmfilepath $SHALLOW_PARSER_BEN/data_bin/sl/morph/ben/ --uwordpath $SHALLOW_PARSER_BEN/data_bin/sl/morph/ben/dict_final --dictfilepath $SHALLOW_PARSER_BEN/data_bin/sl/morph/ben/dict/  -ULDWH --inputfile morphinput$$ --outputfile morphoutput$$
cat morphoutput$$
rm -f morphinput$$ morphoutput$$


