#! /usr/bin/perl

#      This progrm converts the input in tnt to SSF format.
#
=cut
<< '#';
Example of SSF and TNT format:

TNT format:

ikanuMci        NN      B-NP
nenu    PRP     B-NP
saBalU  NN      B-NP
,       SYM     I-NP
saMxarBalU      NN      B-NP
mAnukoVni       VRB     B-VG
iMtipattuna     NN      B-NP
uMdamanI        VRB     B-VG
xIni    PRP     B-NP
BAvaM   NN      I-NP
.       SYM     I-NP

SSF format:

<Sentence id="1">
0       ((      SSF
1       ((      NP
2       ikanuMci        NN
3       ))
4       ((      NP
5       nenu    PRP
6       ))
7       ((      NP
8       saBalU  NN
9       ,       SYM
10      ))
11      ((      NP
12      saMxarBalU      NN
13      ))
14      ((      VG
15      mAnukoVni       VRB
16      ))
17      ((      NP
18      iMtipattuna     NN
19      ))
20      ((      VG
21      uMdamanI        VRB
22      ))
23      ((      NP
24      xIni    PRP
25      BAvaM   NN
26      .       SYM
27      ))
</Sentence>

Given below are SSF format and its corresponding TNT-format
i.e., TNT format contains three fields first is word and second is POS tag and third is chunk name.

psedo code:
Just read each line and if the line has all space charcters then it is assumed to be end of the sentence, if it is a start of new sentence then printing the required thing which represent the start of the sentence. then spliting the line with spaces if the present line represents the start of the new chunk (if the 3rd coumn is B-Chunkname which represents begining of Chunkname chunk) then printing ((\tchunkname and if line represents the middle of the chunk then it checks for inconsistencies by checking whether the previous chunkname and present chunk name is equal or not. then printing the number, word and tag.
#
=cut

sub tnt2ssf
{
	my $line = "";
	my $startFlag = 1;
	my $wno = 1;
	my $prevCTag = "";
	my $error = "";
	my $lno = 0;
	my $sno = 1;

	#scan each line from standard input
	while($line = <>)
	{
	$lno ++;
	if($line =~ /^\s*$/)
	{	# start of a sentence

	if($wno ne 1)
	{
		print "$wno\t))\t\t\n</Sentence>\n\n";
	}
	$startFlag = 1;
	$wno = 1;
	$prevCTag = "";
	$sno ++;
	next;
	}
	if($startFlag == 1)
	{
		print "<Sentence id=\"$sno\">\n0\t((\tSSF\t\n";
	}
	chomp($line);
	my @cols = split(/\t+/,$line);

	if($cols[2] =~ /^B-(\w+)/) 
	{
		my $ctag = $1;
		if($prevCTag ne "O" && $startFlag == 0)
		{
			print "$wno\t))\t\t\n";
			$wno++;
		}
		print "$wno\t((\t$ctag\t\n";
		$wno++;
		$prevCTag = $ctag;
	}
	elsif($cols[2] =~ /^O/)
	{
		if($prevCTag ne "O" && $startFlag == 0)
		{
		print "$wno\t))\t\t\n";
		$wno++;
		}
		$prevCTag = "O"; 
	}

	if($cols[2] =~ /I-(\w+)/ )
	{	# check for inconsistencies .. does not form a chunk if there r inconsistencies
	  my $ctag = $1;
	  if($ctag ne $prevCTag)
	  {
		$error =$error . "Inconsistency of Chunk tag in I-$ctag at Line no:$lno : There is no B-$ctag to the prev. word\n";
	  }
	}

	print "$wno\t$cols[0]\tundef\t$cols[1]\n";
	$wno ++;

	$startFlag = 0;
	}
}
&tnt2ssf;
