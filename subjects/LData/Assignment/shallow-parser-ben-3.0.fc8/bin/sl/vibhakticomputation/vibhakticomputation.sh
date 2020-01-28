perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > vibhakticomputationinput$$
perl $SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/vibhakticomputation.pl --path=$SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation --input=vibhakticomputationinput$$
rm -fr vibhakticomputationinput$$
