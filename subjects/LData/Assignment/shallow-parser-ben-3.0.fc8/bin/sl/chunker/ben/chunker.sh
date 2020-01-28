perl $SHALLOW_PARSER_BEN/bin/sl/chunker/common/ssf2tnt_pos.pl $1 > chunkinput_pos.tnt$$
$SHALLOW_PARSER_BEN/bin/sl/CRF++-0.51/crf_test -m $SHALLOW_PARSER_BEN/data_bin/sl/chunker/ben/model_chunker chunkinput_pos.tnt$$ > chunker_out.tnt$$
perl $SHALLOW_PARSER_BEN/bin/sl/chunker/common/convert_biotossf.pl < chunker_out.tnt$$
rm -f chunkinput_pos.tnt$$ chunker_out.tnt$$ chunker_out.tnt$$ 
