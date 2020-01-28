perl $setu/bin/sys/common/printinput.pl $1 > posinput
$setu/bin/sl/postagger/common/hmm_run --ngram=2 --smoothing=5 --train_para_lex=$setu/data_bin/sl/postagger/hin/train.lex --train_para_123=$setu/data_bin/sl/postagger/hin/train.123 --test=posinput
