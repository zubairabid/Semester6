#!/usr/bin/perl

use Getopt::Long "GetOptions";
$ENV{"LC_ALL"} = "C";
&GetOptions("help!"=>\$help,'mode=s' => \$mode,
		'path=s'=> \$path,
		'stype=s'=>\$stype,
		'slang=s'=>\$slang,
		'tlang=s'=>\$tlang,
		's=s' => \$src,
		't=s' => \$tgt,
	   );
print "Unprocessed by Getopt::Long\n" if $ARGV[0];

foreach (@ARGV) {
        print "$_\n";
        exit(0);
}


if($help eq 1)
{
        print "SSF/TEXT-UTF-WX Convertor  - SSF?TEXT 3.3.2\n(17th Nov 2008 last modified on 10th Nov 2008)\n\n";
        print "usage : ./run-convertor.pl --path=/home/convertor-3.3.2 --stype=text --tlang=hin -s wx -t utf \n";
        print "or ./run-convertor.pl --path=/home/convertor-3.3.2 --stype=ssf --tlang=hin -s wx -t utf \n";
        print "or  ./run-convertor.pl --path=/home/convertor-3.3.2 --stype=text -s utf -t wx --slang=hin \n";
        print "or  ./run-convertor.pl --path=/home/convertor-3.3.2 --stype=ssf -s utf -t wx --slang=hin \n";
        exit(0);
}

if($path eq "")
{
        print "Please Specify the Path as defined in --help\n";
        exit(0);

}
if($stype eq "")
{
        print "Please Specify the Source Language type in ssf/text as defined in --help\n";
        exit(0);

}
if(($slang eq "") and ($src eq "utf"))
{
        print "Please Specify the Source Language as defined in --help\n";
        exit(0);

}
else{
	if($slang eq "")
	{
		$slang = "hin";
	}
}
if(($tlang eq "") and ($src eq "wx"))
{
        print "Please Specify the Target Language as defined in --help\n";
        exit(0);

}
else
{
        if($tlang eq "")
        {
                $tlang = "hin";
        }
}
if($src eq "")
{
        print "Please Specify the Src Font as defined in --help [utf/wx]\n";
        exit(0);

}
if($tgt eq "")
{
        print "Please Specify the Target Font as defined in --help [utf/wx]\n";
        exit(0);

}

my $bin=$path."/bin";
require "$bin/$tlang/wx2utf.pl";
require "$bin/$slang/utf2wx.pl";
require "$path/API/feature_filter.pl";

if($src eq "wx" and $tgt eq "utf")
{
	open(STDIN,"<:utf8");
	while($line=<STDIN>)
        {
                chomp ($line);
		if(($stype eq "SSF") or ($stype eq "ssf"))
                {
                	($num,$lex,$pos,$fs) = split(/\t/,$line);
	                if($lex ne "((" and $lex ne "))")
        	        {
				$flag=0;
				if($lex=~/^\@.*/)
			        {
        	        		($sym,$lex)=split(/\@/,$lex);
					$flag=1;
				}
	                        $srlang = &findlang($lex);
				if($srlang eq "eng")
				{
					if($lex=~m/^[0-9]+$/)
					{
						$lex_out=$lex;
					}
					else{
                        			system("echo $lex > word");
	                        		&wx2utf($path,"word","out_word");
			                        open(FILE1,"out_word");
        			                $lex_out = <FILE1>;
                			        chomp($lex_out);
                        			system("rm -f word out_word");
					}
				}
				else{
					$lex_out=$lex;
				}
				if($flag)
				{	
					$lex_out="@".$lex_out;
				}
	                }
        	        if($fs ne "")
                	{
	                        @fss = split(/\|/,$fs);
        	                my $len = @fss;
                	        @string  = "";
                        	$newfs = "";
	                        my $i=0;
        	                foreach $af (@fss)
                	        {
	                                my $FSreference = &read_FS($af,$line);
        	                        my @lex_root = &get_values("lex",$FSreference);
        	                        my @cat_root = &get_values("cat",$FSreference);
                	                my @fs_vib = &get_values("vib",$FSreference);
                        	        my @fs_head = &get_values("head",$FSreference);
                                	my @fs_name = &get_values("name",$FSreference);
	                                foreach $field (@lex_root)
        	                        {
						$flag=0;
						if($field=~/^\@.*/)
					        {
                					($sym,$field)=split(/\@/,$field);
							$flag=1;
						}
        	                		$srlang = &findlang($field);
						if(($srlang eq "eng") and ($cat_root[0] ne "punc") and ($cat_root[0] ne "num"))
						{
	                        	                system("echo $field > word ");
        	                        	        &wx2utf($path,"word","out_word");
                	                        	open(FILE1,"out_word");
	                        	                $val_out = <FILE1>;
							chomp($val_out);
                                	        	system("rm -f word out_word");
						}
						else{
							$val_out=$field;
						}
						if($flag)
						{
							$val_out="@".$val_out;
						}
                                        	my @lex_arr=();
	                                        push @lex_arr,$val_out;
        	                                &update_attr_val("lex", \@lex_arr,$FSreference,$af);
                	                        $string[$i]=&make_string($FSreference,$af);
                        	        }
                                	foreach $field1 (@fs_vib)
	                                {
						$flag=0;
						if($field1=~/^\@.*/)
					        {
                					($sym,$field1)=split(/\@/,$field1);
							$flag=1;
						}
        	                		$srlang = &findlang($field1);
						if($srlang eq "eng")
						{
	                        	                system("echo $field1 > word ");
        	                        	        &wx2utf($path,"word","out_word");
                	                        	open(FILE1,"out_word");
	                        	                $vib_out = <FILE1>;
        	                        	        chomp($vib_out);
                                	        	system("rm -f word out_word");
						}
						else{
							$vib_out=$field1;
						}
						if($flag)
        	                                {
                	                                $vib_out="@".$vib_out;
                        	                }
                                        	my @fs_vib_arr=();
	                                        push @fs_vib_arr,$vib_out;
        	                                &update_attr_val("vib", \@fs_vib_arr,$FSreference,$af);
                	                        $string[$i]=&make_string($FSreference,$af);
                        	        }
                                	foreach $field (@fs_head)
	                                {
        	                                $flag = 0;
                	                        if($field=~/^\".*\"/)
                        	                {
                                	                $field=~s/\"//g;
                                        	        $flag = 1;
	                                        }	
						$flag1=0;
						if($field=~/^\@.*/)
					        {
                					($sym,$field)=split(/\@/,$field);
							$flag1=1;
						}
        	                		$srlang = &findlang($field);
						if($srlang eq "eng")
						{
	                        	                system("echo $field > word ");
        	                        	        &wx2utf($path,"word","out_word");
                	                        	open(FILE1,"out_word");
	                        	                $val_out = <FILE1>;
        	                        	        chomp($val_out);
	                                        	system("rm -f word out_word");
						}
						else{
							$val_out=$field;
						}
						if($flag1)
        	                                {
                	                                $val_out="@".$val_out;
                        	                }
                                	        if($flag)
						{
                                                	$val_out = "\"".$val_out."\"";
                                        	}
        	                                my @head_arr=();
                	                        push @head_arr,$val_out;
                        	                &update_attr_val("head", \@head_arr,$FSreference,$af);
                                	        $string[$i]=&make_string($FSreference,$af);
	                                }	
        	                        foreach $field (@fs_name)
                	                {
                        	                $flag = 0;
                                	        if($field=~/^\".*\"/)
                                        	{
                                                	$field=~s/\"//g;
	                                                $flag = 1;
        	                                }
						$flag1=0;
						if($field=~/^\@.*/)
					        {
                					($sym,$field)=split(/\@/,$field);
							$flag1=1;
						}
        	                		$srlang = &findlang($field);
						if($srlang eq "eng")
						{
	                        	                system("echo $field > word ");
        	                        	        &wx2utf($path,"word","out_word");
                	                        	open(FILE1,"out_word");
	                        	                $val_out = <FILE1>;
        	                        	        chomp($val_out);
        	                                	system("rm -f word out_word");
						}
						else{
							$val_out=$field;
						}
						if($flag1)
        	                                {
                	                                $val_out="@".$val_out;
                        	                }
                                	        if($flag)
                                        	{
                                                	$val_out = "\"".$val_out."\"";
	                                        }
                	                        my @name_arr=();
                        	                push @name_arr,$val_out;
                                	        &update_attr_val("name", \@name_arr,$FSreference,$af);
                                        	$string[$i]=&make_string($FSreference,$af);
                                	}
	                                $i++;
        	                }
				foreach $string (@string)
				{	
					if(--$len)
					{	
        	                       		$newfs=$newfs.$string."|";
					}
					else
					{
						$newfs=$newfs.$string;
					}
				}
				delete @string[0..$#string];
				delete @lex_root[0..$#lex_root];
				delete @fss[0..$#fss];
				if($line =~ /\(\(/ or $line =~ /\)\)/)
				{
					($num,$lex,$pos,$fs) = split(/\t/,$line);
					print $num,"\t",$lex,"\t",$pos,"\t",$newfs,"\n";
				}
				else
				{
					print $num,"\t",$lex_out,"\t",$pos,"\t",$newfs,"\n";
				}
			}	
			else{
				if($lex ne "((" and $lex ne "))")
				{
					print $num,"\t",$lex_out,"\t",$pos,"\t",$fs,"\n";
				}
				else{
					print $line."\n";
				}
			}
		}
		elsif(($stype eq "TEXT") or ($stype eq "text"))
                {
                        @words = split(/\s/,$line);
                        $symbol=0;
                        $symbol1=0;
                        foreach $lex (@words)
                        {
                                if($lex=~/^\@.*/)
                                {
                                        ($sym,$lex)=split(/\@/,$lex);
                                        print "\@";
                                }
                                elsif($lex=~/^\‘.*/)
                                {
                                        if($lex=~/^\‘.*\‘/)
                                        {
                                                ($lex,$sym)=split(/\‘/,$lex);
                                                $symbol4=1;
                                        }
                                        ($sym,$lex)=split(/\‘/,$lex);
                                        print FA "\‘";
                                }
                                elsif($lex=~/^.*\‘/)
                                {
                                        ($lex,$sym)=split(/\‘/,$lex);
                                        $symbol4=1;
                                }
                                elsif($lex=~/^\'.*/)
                                {
                                        if($lex=~/^\'.*\'/)
                                        {
                                                $symbol=1;
                                        }
                                        ($sym,$lex)=split(/\'/,$lex);
                                        print "\'";
                                }
                                elsif($lex=~/^.*\'/)
                                {
					($lex,$sym)=split(/\'/,$lex);
                                        $symbol=1;
                                }
                                elsif($lex=~/^\`.*/)
                                {
                                        if($lex=~/^\`.*\`/)
                                        {
                                                $symbol3=1;
                                        }
                                        ($sym,$lex)=split(/\`/,$lex);
                                        print "\`";
                                }
                                elsif($lex=~/^.*\`/)
                                {
                                        ($lex,$sym)=split(/\`/,$lex);
                                        $symbol3=1;
                                }
                                elsif($lex=~/^\(.*/)
                                {
                                        ($sym,$lex)=split(/\(/,$lex);
                                        print "\(";
                                        if($lex=~/^.*\)/)
                                        {
                                                ($lex,$sym)=split(/\)/,$lex);
                                                $symbol2 =1;
                                        }
                                }
                                elsif($lex=~/^.*\)/)
                                {
                                        ($lex,$sym)=split(/\)/,$lex);
                                        $symbol2=1;
                                }
                                elsif($lex=~/^\".*/)
                                {
                                        if($lex=~/^\".*\"/)
                                        {
						$symbol1=1;
                                        }
                                        ($sym,$lex)=split(/\"/,$lex);
                                        print "\"";
                                }
                                else{
                                        if($lex=~/^.*\"/)
                                        {
                                                ($lex,$sym)=split(/\"/,$lex);
                                                $symbol1=1;
                                        }
                                }
	                        $srlang = &findlang($lex);
				if($srlang eq "eng")
				{
                                	system("echo $lex > word");
	                                &wx2utf($path,"word","out_word");
        	                        open(FILE1,"out_word");
                	                $lex_out = <FILE1>;
                        	        chomp($lex_out);
                                	system("rm -f word out_word");
				}
                                else
                                {
                                        $lex_out = $lex;
                                }
                                if(!$symbol and !$symbol1 and !$symbol2 and !$symbol3)
                                {
                                        print $lex_out." ";
                                }
                                elsif($symbol){
                                        print $lex_out."\' ";
                                }
                                elsif($symbol2){
                                        print $lex_out."\) ";
                                }
                                elsif($symbol3){
                                        print $lex_out."\` ";
                                }
                                elsif($symbol4){
                                        print $lex_out."\‘ ";
				}
                                else{
                                        print $lex_out."\" ";
                                }
                                $symbol =0;
                                $symbol1 =0;
                                $symbol2 =0;
                                $symbol3 =0;
                        }
                        print "\n";
                }
        }
}
elsif($src eq "utf" and $tgt eq "wx")
{
	open(STDIN,"<:utf8");
	while($line = <STDIN>)
	{
		chomp ($line);
		if(($stype eq "SSF") or ($stype eq "ssf"))
                {
			($num,$lex,$pos,$fs) = split(/\t/,$line);
			
			if($lex ne "((" and $lex ne "))")
			{
				$flag=0;
			        if($lex=~/^\@.*/)
		        	{
                			($sym,$lex)=split(/\@/,$lex);
			                $flag=1;
				}
	        	        $srlang = &findlang($lex);
				if(($slang eq "mar") and ($srlang eq "hin"))
				{
					$srlang="mar";
				}
				if($srlang=~/$slang/)
				{
					system("echo $lex > word");
					&utf2wx($path,"word","out_word");
					open(FILE1,"out_word");
					$lex_out = <FILE1>;
					chomp($lex_out);
					system("rm -f word out_word");
				}
				else
				{
					$lex_out = $lex;
				}
				if($flag)
				{
					$lex_out="@".$lex_out;
				}
			}
			if($fs ne "")
			{
				@fss = split(/\|/,$fs);
				my $len = @fss;
				@string  = "";
				$newfs = "";
				my $i=0;
				foreach $af (@fss)
				{
					my $FSreference = &read_FS($af,$line);
					my @lex_root = &get_values("lex",$FSreference);
					my @fs_vib = &get_values("vib",$FSreference);
					my @fs_head = &get_values("head",$FSreference);
		                        my @fs_name = &get_values("name",$FSreference);
					foreach $field (@lex_root)
					{
						$flag=0;
					        if($field=~/^\@.*/)
				        	{
                					($sym,$field)=split(/\@/,$field);
					                $flag=1;
						}
			                        $srlang = &findlang($field);
						if(($slang eq "mar") and ($srlang eq "hin"))
						{
							$srlang="mar";
						}
						if($srlang=~/$slang/)
						{
							system("echo $field > word ");
							&utf2wx($path,"word","out_word");
							open(FILE1,"out_word");
							$val_out = <FILE1>;
							chomp($val_out);
							system("rm -f word out_word");
						}
						else{
							$val_out=$field;
						}
						if($flag)
						{
							$val_out="@".$val_out;
						}
						my @lex_arr=();
						push @lex_arr,$val_out;
						&update_attr_val("lex", \@lex_arr,$FSreference,$af);
						$string[$i]=&make_string($FSreference,$af);
					}
					foreach $field1 (@fs_vib)
                       	        	{
						$flag=0;
					        if($field1=~/^\@.*/)
					        {
                					($sym,$field1)=split(/\@/,$field1);
					                $flag=1;
						}
		                        	$srlang = &findlang($field1);
						if(($slang eq "mar") and ($srlang eq "hin"))
						{
							$srlang="mar";
						}
						if($srlang=~/$slang/)
						{
							system("echo $field1 > word ");
							&utf2wx($path,"word","out_word");
			                               	open(FILE1,"out_word");
	        			               	$vib_out = <FILE1>;
	        		        	        chomp($vib_out);
                                        		system("rm -f word out_word");
						}
						else{
							$vib_out=$field1;
						}
						if($flag)
						{
                        	                        $vib_out="@".$vib_out;
                                	        }
	                               	        my @vib_arr=();
        	                               	push @vib_arr,$vib_out;
	        	                        &update_attr_val("vib", \@vib_arr,$FSreference,$af);
        	        	                $string[$i]=&make_string($FSreference,$af);
                	        	}
					foreach $field (@fs_head)
		                        {
        		        	        $flag=0;
                		                if($field=~/^\".*\"/)
                        		        {
	                                                $field=~s/\"//g;
        	                               	        $flag = 1;
	        	                        }
						$flag1=0;
					        if($field=~/^\@.*/)
				        	{
                					($sym,$field)=split(/\@/,$field);
					                $flag1=1;
						}
			                        $srlang = &findlang($field);
						if(($slang eq "mar") and ($srlang eq "hin"))
						{
							$srlang="mar";
						}
						if($srlang=~/$slang/)
						{
							system("echo $field > word ");
							&utf2wx($path,"word","out_word");
        	                		        open(FILE1,"out_word");
                	                		$head_out = <FILE1>;
			                               	chomp($head_out);
        	                	       		system("rm -f word out_word");
						}
						else{
							$head_out=$field;
						}
						if($flag1)
						{
        	                                        $head_out="@".$head_out;
                	                        }
	                	                if($flag)
	        	        	        {
        	        	        		$head_out = "\"".$head_out."\"";
	                	        	}
                	                        my @head_arr=();
	                	                push @head_arr,$head_out;
        	                	        &update_attr_val("head", \@head_arr,$FSreference,$af);
                	                	$string[$i]=&make_string($FSreference,$af);
	                        	}
        	                        foreach $field (@fs_name)
	        	                {
        	        	        	$flag=0;
                	        	        if($field=~/^\".*\"/)
                        	        	{
                                			$field=~s/\"//g;
	                                        	$flag = 1;
		                                }
						$flag1=0;
					        if($field=~/^\@.*/)
					        {
                					($sym,$field)=split(/\@/,$field);
				                	$flag1=1;
						}
			                        $srlang = &findlang($field);
						if(($slang eq "mar") and ($srlang eq "hin"))
						{
							$srlang="mar";
						}
						if($srlang=~/$slang/)
						{
							system("echo $field > word ");
							&utf2wx($path,"word","out_word");
        	                		        open(FILE1,"out_word");
                	                		$name_out = <FILE1>;
	                        	       		chomp($name_out);
	                                		system("rm -f word out_word");
						}
						else{
							$name_out=$field;
						}
						if($flag1)
						{
							$name_out="@".$name_out;
						}
		                                if($flag)
        		                        {
						         $name_out = "\"".$name_out."\"";
        	                	        }
	                	                my @name_arr=();
        	                	        push @name_arr,$name_out;
                	                	&update_attr_val("name", \@name_arr,$FSreference,$af);
                        	               	$string[$i]=&make_string($FSreference,$af);
	                        	}
					$i++;
				}
				foreach $string (@string)
				{
					if(--$len)
					{
						$newfs=$newfs.$string."|";
					}
					else
					{
						$newfs=$newfs.$string;
					}
				}
				delete @string[0..$#string];
				delete @lex_root[0..$#lex_root];
				delete @fss[0..$#fss];
				if($line =~ /\(\(/ or $line =~ /\)\)/)
				{
					($num,$lex,$pos,$fs) = split(/\t/,$line);
					print $num,"\t",$lex,"\t",$pos,"\t",$newfs,"\n";                       
			        }
				else
				{
					print $num,"\t",$lex_out,"\t",$pos,"\t",$newfs,"\n";
				}
			}
			else{
	                       	if($lex ne "((" and $lex ne "))")
		                {
        		               	print $num,"\t",$lex_out,"\t",$pos,"\t",$fs,"\n";
                        	}
	                       	else{
		                        print $line."\n";
        		        }
                	}
		}
		elsif(($stype eq "TEXT") or ($stype eq "text"))
                {
                        @words = split(/\s/,$line);
                        $symbol=0;
                        foreach $lex (@words)
                        {
                                if($lex=~/^\@.*/)
                                {
                                        ($sym,$lex)=split(/\@/,$lex);
                                        print "\@";
                                }
                                elsif($lex=~/^\'.*/)
                                {
                                        if($lex=~/^\'.*\'/)
                                        {
                                                $symbol=1;
                                        }
                                        ($sym,$lex)=split(/\'/,$lex);
                                        print "\'";
                                }
                                elsif($lex=~/^.*\'/)
                                {
                                        ($lex,$sym)=split(/\'/,$lex);
                                        $symbol=1;
                                }
                                elsif($lex=~/^\`.*/)
                                {
                                        if($lex=~/^\`.*\`/)
                                        {
                                                $symbol3=1;
                                        }
                                        ($sym,$lex)=split(/\`/,$lex);
                                        print "\`";
                                }
                                elsif($lex=~/^.*\`/)
                                {
                                        ($lex,$sym)=split(/\`/,$lex);
                                        $symbol3=1;
				}
                                elsif($lex=~/^\(.*/)
                                {
                                        ($sym,$lex)=split(/\(/,$lex);
                                        print "\(";
                                        if($lex=~/^.*\)/)
                                        {
                                                ($lex,$sym)=split(/\)/,$lex);
                                                $symbol2 =1;
                                        }
                                }
                                elsif($lex=~/^.*\)/)
                                {
                                        ($lex,$sym)=split(/\)/,$lex);
                                        $symbol2=1;
                                }
                                elsif($lex=~/^\".*/)
                                {
                                        if($lex=~/^\".*\"/)
                                        {
                                                $symbol1=1;
                                        }
                                        ($sym,$lex)=split(/\"/,$lex);
                                        print "\"";
                                }
                                else{
                                        if($lex=~/^.*\"/)
                                        {
                                                ($lex,$sym)=split(/\"/,$lex);
                                                $symbol1=1;
                                        }
                                }
				$srlang = &findlang($lex);
	                        if(($slang eq "mar") and ($srlang eq "hin"))
        	                {
                	                $srlang="mar";
                        	}
				if(($lex=~/^\|.*/) and (($slang eq "hin") or ($slang eq "mar")))
				{
					$lex=~s/\|/\./g;
				}
	                        if($srlang=~/$slang/)
	                        {
                                	system("echo $lex > word ");
					&utf2wx($path,"word","out_word");
        	                        open(FILE1,"out_word");
                	                $lex_out = <FILE1>;
                        	        chomp($lex_out);
                                	system("rm -f word out_word");
				}
                                else
                                {
                                        $lex_out = $lex;
                                }
                                if(!$symbol and !$symbol1 and !$symbol2 and !$symbol3)
                                {
                                        print $lex_out." ";
                                }
                                elsif($symbol){
                                        print $lex_out."\' ";
                                }
                                elsif($symbol2){
                                        print $lex_out."\) ";
                                }
                                elsif($symbol3){
                                        print $lex_out."\` ";
                                }
                                else{
                                        print $lex_out."\" ";
                                }
                                $symbol =0;
                                $symbol1 =0;
                                $symbol2 =0;
                                $symbol3 =0;
                        }
                        print "\n";
                }
	}
}

sub findlang
{
        $infile =$_[0];
        system("echo $_[0] > lanword");
        open(FILE, "<:utf8", "lanword");
        $word = <FILE>;
	if($word=~/([0-9]+\_)(.*)/)
	{
		$word=$2;
	}
        @letter = split(//,$word);
        $val = ord($letter[0]);
	system("rm -f lanword");

        if($val >= 2304 and $val <= 2431)
        {
                $result = "hin";
        }
        elsif($val >= 2432 and $val <= 2559)
        {
                $result = "ben";
        }
        elsif($val >= 2560 and $val <= 2659)
        {
                $result = "pan";
        }
        elsif($val >= 2944 and $val <= 3071)
        {
                $result = "tam";
        }
        elsif($val >= 3072 and $val <= 3199)
        {
                $result = "tel";
        }
        elsif($val >= 3200 and $val <= 3327)
	{
                $result = "kan";
        }
        elsif($val >= 3328 and $val <= 3455)
        {
                $result = "mal";
        }
        elsif($val >= 1536 and $val <= 1791)
        {
                $result = "urd";
        }
        else
        {
                $result = "eng";
        }
        return $result;
}

