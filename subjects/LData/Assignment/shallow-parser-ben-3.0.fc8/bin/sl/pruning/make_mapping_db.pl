#!/usr/bin/perl 

use GDBM_File;

sub make_mapping_db
{

	my ($datafile,$dbfile)=@_;
	
	open(DICT,$datafile) or die "Error in opening dictionary : $datafile\n";
	
	if(-e $dbfile)
	{
		unlink $dbfile or die "Error in removing db file : $dbfile\n";
	}
	
	dbmopen(%DICT,$dbfile,0777);

	while(<DICT>)
	{
		chomp($input=$_);
		@arr=split(/\t/,$input);
		if(!$DICT{$arr[0]})
		{
			$DICT{$arr[0]} = $arr[1];
		}
	}
	dbmclose(%DICT);
	close(DICT);
}
&make_mapping_db(@ARGV[0],@ARGV[1]);
