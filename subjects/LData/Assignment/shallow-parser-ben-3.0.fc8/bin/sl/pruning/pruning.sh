perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > pruneinput$$
perl $SHALLOW_PARSER_BEN/bin/sl/pruning/pruning.pl --path=$SHALLOW_PARSER_BEN/bin/sl/pruning --resource=$SHALLOW_PARSER_BEN/data_bin/sl/pruning/mapping.db --input=pruneinput$$
rm -fr pruneinput$$
