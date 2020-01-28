perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > headcomputationinput$$
perl $SHALLOW_PARSER_BEN/bin/sl/headcomputation/headcomputation.pl --path=$SHALLOW_PARSER_BEN/bin/sl/headcomputation --input=headcomputationinput$$
rm -fr headcomputationinput$$
