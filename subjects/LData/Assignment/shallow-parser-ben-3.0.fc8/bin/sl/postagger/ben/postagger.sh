perl $SHALLOW_PARSER_BEN/bin/sys/common/printinput.pl $1 > posinput$$

$SHALLOW_PARSER_BEN/bin/sl/postagger/common/hmm_run --ngram=2 --smoothing=5 --train_para_lex=$SHALLOW_PARSER_BEN/data_bin/sl/postagger/train.lex --train_para_123=$SHALLOW_PARSER_BEN/data_bin/sl/postagger/train.123 --test=posinput$$

rm -fr posinput$$
