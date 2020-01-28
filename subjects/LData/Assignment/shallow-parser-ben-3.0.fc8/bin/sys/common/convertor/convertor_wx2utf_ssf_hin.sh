perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > convertorinput
perl $SHALLOW_PARSER_BEN/bin/sys/common/convertor/convertor.pl --path=$SHALLOW_PARSER_BEN/bin/sys/common/convertor --stype=ssf --tlang=hin -s wx -t utf < convertorinput

