#!/usr/bin/perl


# This program takes input as file which contains data in SSF format and outputs the features like last 4 letters of the word and so on..(refer to README file for more features) in TNT format.

<< '#';
 Example of SSF and TNT format:

SSF format:
1       ((      SSF
2       children        NNS
5       are     VBP
6       watching        VBG
9       some    DT
10      programmes      NNS
12      on      IN
14      television      NN
16      in      IN
18      the     DT
19      house   NN
20      ))

TNT format:

children        NNS
are     VBP
watching        VBG
some    DT
programmes      NNS
on      IN
television      NN
in      IN
the     DT
house   NN

Given below are SSF format and its corresponding TNT-format
i.e., TNT format contains two fields first is word and second is POS tag.

 psedo code:
Just read each line and if the line has all space charcters then print \n and continue else split the line with space(or tab ) and if the first word starts with < (sometimes in SSF format sentence ID is represented by "<Sentence Id=1>" so we have to ignore it)or second word is (( or )) (as seen above (( and )) have no information so we can ignore it)then it is unwanted line so ignore it and else print 2nd word and 3rd word.

#
sub ssf2tnt {
	#$filename=@ARGV[0];
	#chomp($filename);
	#open(FP,$filename);
	my $line;
	#while ($line = <FP>)
	while ($line = <>)
	{
		chomp($line);
		if($line =~ /^\s*$/)  # if the line has all space charcters 
		{
			print "";
			next;
		}
		my ($att1,$att2,$att3) = split (/[\t]+/, $line);
		if($att1 =~ /$\<.*/ || $att2 eq "((" || $att2 eq "))") #unwanted lines
		{
			next;
		}
		else
		{
			print $att2,"\n";
		}
	}
	print "\n";
}
&ssf2tnt;
