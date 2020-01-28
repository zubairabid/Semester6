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

# Pruning
sh $SHALLOW_PARSER_BEN/bin/sl/pruning/pruning.sh $2/chunker.tmp > $2/pruning.tmp
# Pickone Morph
sh $SHALLOW_PARSER_BEN/bin/sl/pickonemorph/pickonemorph.sh $2/pruning.tmp > $2/pickonemorph.tmp
# Head Computation
sh $SHALLOW_PARSER_BEN/bin/sl/headcomputation/headcomputation.sh $2/pickonemorph.tmp > $2/headcompute.tmp
# Vibhakti Computation
sh $SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/vibhakticomputation.sh $2/headcompute.tmp > $2/vibcompute.tmp
perl $SHALLOW_PARSER_BEN/bin/sl/vibhakticomputation/printinput.pl $2/vibcompute.tmp 
# Language Independent Module end

