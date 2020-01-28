#!/usr/bin/perl

use GDBM_File;


# traverse all the node of SSF tree and delete the FS which is incompitable with POS

sub prune_on_pos
{
	$db_file=@_[0];
	$sent=@_[1];
#	&print_tree();
	dbmopen(%mapping, "$db_file",0666) || die "couldnot open mapping.db";

	my($parent);
	my($fs,@attr,@index);

	my @val=["\"NM\""];
	@index = &get_leaves($sent);
	for($i=0 ; $i<=$#index ; $i++)
	{
		
		($f0,$f1,$f2,$f3,$f4) = &get_fields($index[$i],$sent);
		$cat = $mapping{$f3};
		#print "f3= $f3 cat = $cat\n";
		$fs_ptr = &read_FS($f4,$sent);
		$num_of_fs = &get_num_fs($fs_ptr,$sent);
		my $flag=0;
		my $match=0;
		#my ($pflag, $sh_pflag, $Dflag, $nflag) = 0;
		
		if($num_of_fs==1)
		{
			@attr = &get_values("cat",$fs_ptr,$sent);
			$string=&make_string($fs_ptr,$sent);
			if(($attr[0]) ne ($cat))
			{
				&add_attr_val("poslcat",@val,$fs_ptr,$sent);
				$string=&make_string($fs_ptr,$sent);
				&modify_field($index[$i],4,$string,$sent);
			}
		}

		
		if($num_of_fs>1)
		{
			#print stderr "FS more than one for $f2\n";
			###this section added to handle PRP,QF,QFN
			$deleted_fs = 0;
			$flag=0;
			$match=0;
			for($j=$num_of_fs; $j>=0; $j--)
			{
				$fs = &get_fs_reference($fs_ptr,$j,$sent);
				$string=&make_string_2($fs,$sent);
				@attr = &get_values_2("cat",$fs,$sent);
				#if(@attr > 0 and lc($attr[0]) ne lc($cat))
				if(($attr[0]) ne ($cat))
				{
					
					if($match==1)
					{
						$ret=&prune_FS("",$j,$fs_ptr,$sent);
						$deleted_fs++;
					}
					else
					{
						
						&add_attr_val_2("poslcat",@val,$fs,$sent);
						$string=&make_string($fs_ptr,$sent);
						&modify_field($index[$i],4,$string,$sent);
					}
					
				}
				if($attr[0] eq $cat)
				{
					$match=1;
				}
				if(($deleted_fs+1) == $num_of_fs)
				{
#print stderr "END NOW....$num_of_fs\n";
					last;
				}
			}
			if($match==1)
			{
				for($j=$num_of_fs; $j>=0; $j--)
				{
					$fs = &get_fs_reference($fs_ptr,$j,$sent);
					$string=&make_string_2($fs,$sent);
					@attr = &get_values_2("cat",$fs,$sent);
#if(@attr > 0 and lc($attr[0]) ne lc($cat))
					if(@attr > 0 and ($attr[0]) ne ($cat))
					{
							$ret=&prune_FS("",$j,$fs_ptr,$sent);
							$deleted_fs++;

					}
					if($attr[0] eq $cat)
					{
						$match=1;
					}
					if(($deleted_fs+1) == $num_of_fs)
					{
#print stderr "END NOW....$num_of_fs\n";
						last;
					}
				}
			}
##add the category into the feature structure to make sure that for cases in which morph does not give category...
			##we make sure that each lexical item has a category in the feature structure.
			my @catgry;
			my @val_temp = &get_values("cat", $fs_ptr,$sent);
			if($val_temp[0] eq "")#check if already exist..
			{
				$catgry[0] = $cat;
				#print stderr "----> $cat\n";
				&update_attr_val("cat",\@catgry,$fs_ptr);
			}

			$string=&make_string($fs_ptr,$sent);
			&modify_field($index[$i],4,$string,$sent);
		}
		else
		{
			##add the category into the feature structure to make sure that for 
			##cases in which morph does not give any category...
			##we make sure that each lexical item has a category in the feature structure.
			my @catgry;
			my @val_temp = &get_values("cat", $fs_ptr,$sent);
			if($val_temp[0] eq "")#check if already exist..change only when 'cat' is empty
			{
				$catgry[0] = $cat;
				&update_attr_val("cat",\@catgry,$fs_ptr,$sent);
			}

			$string=&make_string($fs_ptr,$sent);
			&modify_field($index[$i],4,$string,$sent);

		}
	}
	dbmclose(mapping);
#	&print_tree_file("prune_on_pos.tmp");
}
1;
