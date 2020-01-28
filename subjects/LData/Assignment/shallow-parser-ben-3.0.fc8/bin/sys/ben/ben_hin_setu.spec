%SPEC_FILE%
#
# Generated Dashboard Specification file 
# This file gives the specifications to run the system. It contains:
#DO NOT change the naming convention of any of the sections.


%GLOBAL%
#
# Global variables 
#

# Root directory of the system
<ENV>$mt_iiit=/usr/share/Dashboard
<ENV>$SHALLOW_PARSER_BEN=/home/benhinilmt/sampark
<ENV>$src=$SHALLOW_PARSER_BEN/src
<ENV>$bin=$SHALLOW_PARSER_BEN/bin
<ENV>$data_bin=$SHALLOW_PARSER_BEN/data_bin
<ENV>$data_src=$SHALLOW_PARSER_BEN/data_src
<ENV>$val_data=$SHALLOW_PARSER_BEN/val_data

# Other variables used in the generation of executable
# type=int, char, char*
<VAR>$slang=ben
<VAR>$tlang=hin
<VAR>$stlang=ben_hin

# API for PERL,C language
<API lang=perl>$mt_iiit/lib/shakti_tree_api.pl
<API lang=perl>$mt_iiit/lib/feature_filter.pl
<API lang=C>$mt_iiit/c_api_v1/c_api_v1.h
# READER,PRINTER function for language PERL
<READER lang=perl>read
<PRINTER lang=perl>print_tree_file

# READER,PRINTER function for language C
<INCLUDE lang=C>stdio.h
<INCLUDE lang=C>stdlib.h
<READER lang=C>read_ssf_from_file
<PRINTER lang=C>print_tree_to_file

# Output directory for storing temporaries (relative path to current dir)
#<OUTPUT_DIR>OUTPUT.tmp
#<OUTPUT_DIR>$val_data/system/$stlang
<OUTPUT_DIR>/home/benhinilmt/OUTPUT.tmp

# Run in SPEED or DEBUG or USER mode
<MODE>DEBUG
#<MODE>SPEED


%SYSTEM%

# Each module should have a unique identifying name (i.e. unique value for the second column)

# -----------------------------------------------
# Source Language Analyzer Modules (SL)
# -----------------------------------------------

# Morph Analyzer
1	morph		$bin/sl/morph/ben/morph.sh	dep=<START>	intype=1	lang=sh

# Pos Tagger
2	postagger	$bin/sl/postagger/ben/postagger.sh	dep=<PREV>	lang=sh

# Chunker
3	chunker		$bin/sl/chunker/ben/chunker.sh	dep=<PREV>	lang=sh

# Prunning 
4	pruning		$bin/sl/pruning/pruning.sh	dep=<PREV>	intype=1	lang=sh

# Pick one Morph Feature
5	pickonemorph	$bin/sl/pickonemorph/pickonemorph.sh	dep=<PREV>	intype=1	lang=sh

# Head Computation
6	headcompute	$bin/sl/headcomputation/headcomputation.sh	dep=<PREV>	intype=1	lang=sh

# Vibhakti Computation
7	vibhcompute	$bin/sl/vibhakticomputation/vibhakticomputation.sh	dep=<PREV>	intype=1	lang=sh

# NER
8	ner	$bin/sl/ner_ben/ner_ben.sh	dep=<PREV>	intype=1	lang=sh

# Simple Parser
9	parser	$bin/sl/simple_parser/simple_parser_engine.sh	dep=<PREV>	intype=1	lang=sh

# Root to Infinity
10	root_infinity	$bin/sl_tl/root_to_inf/root_to_infinity.sh	dep=<PREV>	intype=1	lang=sh

# WSD
#11	wsd	$bin/sl/wsd/wsd.sh	dep=<PREV>	intype=1	lang=sh

# --------------------------------------------------
# Source to Target Language Transfer Modules (SL-TL)
# --------------------------------------------------

# Transfer Grammer
12	transfer_grammer	$bin/sl_tl/transfergrammar/transfergrammar.sh	dep=<PREV>	intype=1	lang=sh

# Lexical Substitution

13	lexical_transfer	$bin/sl_tl/lexicaltransfer/ben/lexicaltransfer.sh	dep=<PREV>	intype=1	lang=sh

# Transliteration
14	transliteration		$bin/sl_tl/transliteration/transliteration_ben2hin_ssf.sh	dep=<PREV>	intype=1	lang=sh


# --------------------------------------------------
# Target Generation Modules (TL)
# --------------------------------------------------

# Agreement Feature
15	agreement_feature	$bin/tl/agreementfeature/agreementfeature.sh	dep=<PREV>	intype=1	lang=sh

# Vibhakti Spliter
16	vibhakti_spliter	$bin/tl/vibhaktispliter/vibhaktispliter.sh	dep=<PREV>	intype=1	lang=sh

# Interchunk
17	interchunk	$bin/tl/interchunk/interchunk.sh	dep=<PREV>	intype=1	lang=sh

# Intrachunk
18	intrachunk	$bin/tl/intrachunk/intrachunk.sh	dep=<PREV>	intype=1	lang=sh

# Agreement Distribution
19	agreement_distribution	$bin/tl/agreementdistribution/agreementdistribution.sh	dep=<PREV>	intype=1	lang=sh

# Infinity to root
20	infinity_root	$bin/tl/infinity_to_root/infinity_to_root.sh	dep=<PREV>	intype=1	lang=sh

# Word Generator
21	wordgen		$bin/tl/wordgenerator/hin/hinwordgen/hinwordgen.sh	dep=<PREV>	intype=1	lang=sh
