perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > pickonemorphinput$$ 
perl $SHALLOW_PARSER_BEN/bin/sl/pickonemorph/pickonemorph.pl --path=$SHALLOW_PARSER_BEN/bin/sl/pickonemorph --input=pickonemorphinput$$
rm -fr pickonemorphinput$$
