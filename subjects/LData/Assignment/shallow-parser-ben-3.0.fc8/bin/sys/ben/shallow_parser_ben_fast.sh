# Language Independent Module start

# Tokenizer
sh $SHALLOW_PARSER_BEN/bin/sl/tokenizer/tokenizer.sh $1 > $2/tokenizer.tmp

# Language Independent Module end




# Language Specific (Hindi) Module start

# Morph Analyzer
sh $SHALLOW_PARSER_BEN/bin/sl/morph/ben/morph.sh $2/tokenizer.tmp > $2/morph.tmp
# POS Tagger
sh $SHALLOW_PARSER_BEN/bin/sl/postagger/ben/postagger.sh $2/morph.tmp > $2/postagger.tmp
# Chunker
sh $SHALLOW_PARSER_BEN/bin/sl/chunker/ben/chunker.sh $2/postagger.tmp > $2/chunker.tmp

# Language Specific Module end


# Language Independent Modules start

# PRUNING , PICK ONE MORPH, HEAD COMPUTATION, VIBHAKTI COMPUTATION
perl $SHALLOW_PARSER_BEN/bin/sl/pruning/pruning.pl --path=$SHALLOW_PARSER_BEN/bin/sl/pruning/ --resource=$SHALLOW_PARSER_BEN/data_bin/sl/pruning/mapping.db < $2/chunker.tmp | perl $SHALLOW_PARSER_BEN/bin/sl/pickonemorph/pickonemorph.pl --path=$SHALLOW_PARSER_BEN/bin/sl/pickonemorph/ | perl $SHALLOW_PARSER_BEN/bin/sl/headcomputation/headcomputation.pl --path=$SHALLOW_PARSER_BEN/bin/sl/headcomputation/ | perl $SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/vibhakticomputation.pl --path=$SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/ | perl $SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/printinput.pl 
# Language Independent Module end

