#!/bin/sh

# This shell file used for training the pos tagger
if [ $# -eq 0 ]
then
	echo "Error - Training file missing from command line arguments"
	echo -e "Syntax :\n$0 <annotated_training_file> <name_training parameter_lex> <name_training parameter_123>";
	echo -e " <annotated_training_file> is the POS Tagged and Chunked file in SSF format";
	echo -e " <name_training paramater_lex> and <name_training parameter> are the parameters generated from Training";
exit 1
fi

echo "Preparing the Training Parameter....";

# This perl programm convert SSF input to TNT format
#perl ssf2tnt.pl $1 > data_src/hin/chunked_hin_datawx_final.tnt
perl ssf2tnt.pl $1 > postagger.$$.tnt

# This HMM Tagger exe is genarate the training parameters
./common/hmm_train --train=postagger.$$.tnt --output_lex=$2 --output_123=$3

#rm /tmp/postagger.$$.tnt

echo "Training Parameters are Created Successfully!....";
