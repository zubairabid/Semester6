#!/usr/bin/perl

#use GDBM_File;
#the module prunes multiple feature structure (NN, NNP, PRP at present), it also removes the parsarg node in the NP and adds it to its noun fs.
#$&compute_vibhakti;
sub ComputeVibhakti
{
	my $sent=@_[0];
	my $vibh_home = @_[1];

	#my $delete;	#keeps count of all the deleted node, helps in locating node obtained before deletion.

	#get all the noun nodes in the tree, the noun will be case marked '1' if a vibhakti is present, else case is '0'

	#my @all_leaves = &get_leaves();
	#&read(@_[0]);	
	my @all_children =&get_nodes(3,"NP",$sent);
		
	foreach $node (@all_children)
	{
		$vibh_chunk="";
		my @node_leaves=&get_leaves_child($node,$sent);
		foreach $NP_child(@node_leaves)
		{
			my $pos = &get_field($NP_child,3,$sent);
			my $word = &get_field($NP_child,2,$sent);

			if($pos eq "PSP")
			{

				my $val_fs=&get_field($NP_child, 4,$sent);

			#	print "val_fs ---",$val_fs,"\n";
				$FSreference = &read_FS($val_fs,$sent);
				my @cur_vibhakti = &get_values("lex",$FSreference); 
			#	print "val ---",@cur_vibhakti[0],",",@cur_vibhakti[1],"\n";
				#get the post-position in the previous node's fs
				if($vibh_chunk)
				{
					$vibh_chunk=$vibh_chunk . "_" . $cur_vibhakti[0];
				}
				else
				{
					$vibh_chunk="0_".$cur_vibhakti[0];
				}
			#	print "vibhchunk---$vibh_chunk\n";
				push(@remove,$NP_child);

			}
			if($vibh_chunk)
			{
			#	print "vibhchunk---$vibh_chunk\n";
				my @vibh_chunk_arr=();
				push @vibh_chunk_arr,$vibh_chunk;

				my $head_node=&get_field($node,4,$sent);
				my $FSreference1 = &read_FS($head_node,$sent);
				&update_attr_val("vib", \@vibh_chunk_arr,$FSreference1,$sent);
				my $string=&make_string($FSreference1,$sent);

				#print "--->$string\n";
				&modify_field($node,4,$string,$sent);

				undef $head_word;
				undef $new_string;
			}
		}
	}

	$delete=0;
	foreach (@remove)
	{
		&delete_node($_-$delete,$sent);
		$delete++;
	}
	delete @remove[0..$#remove];
}
1;
