#!/usr/bin/perl

sub ComputeTAM() 
{
	my $sent=@_[0];
	my $vibh_home = @_[1];
	my $slang = @_[2];

	my @uns_VG_nodes = &get_nodes(3,"VGF",$sent);	#get all the VG nodes
	my @VGINF_nodes = &get_nodes(3,"VGINF",$sent);	#get all the VG nodes
	my @VGNF_nodes = &get_nodes(3,"VGNF",$sent);	#get all the VG nodes
	my @VGNN_nodes = &get_nodes(3,"VGNN",$sent);	#get all the VG nodes
	
	foreach (@VGINF_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	foreach (@VGNF_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	foreach (@VGNN_nodes)
	{
        	push(@uns_VG_nodes,$_);
	}
	
	my @remove;
	my @VG_nodes = sort {$a <=> $b}(@uns_VG_nodes);	
	foreach $node (@VG_nodes)
	{
		my @leaves = &get_leaves_child($node,$sent);
		my $parent = $node;
		my $head = 0;
		my $final_tam_aux = "";
		my $neg = "";
		$fs_array_head = "";	
		$verb_leaf_present = 0;
		my $flag=0;
		my @final_tam;
		my @_leaf;
		foreach $leaf (@leaves)
		{
			$leaf_tag = &get_field($leaf, 3,$sent);
			if($leaf_tag =~ /^V/)
			{
				$verb_leaf_present = 1;
			}
		}
 
		foreach $leaf (@leaves)
		{
			$leaf_tag = &get_field($leaf, 3,$sent);
			$leaf_lex = &get_field($leaf, 2,$sent);
			if($leaf_tag =~/^V/ and $head == 0)	
			{

				$head = 1;
				$node_head = $leaf;
				$fs = &get_field($leaf, 4,$sent);
				$fs_array = &read_FS($fs,$sent);
				$fs_array_head = $fs_array;
				@tam = &get_values("vib", $fs_array,$sent);

				for(my $i = 0; $i < scalar(@tam); $i++)
				{
					if($tam[$i] ne "")
					{
						$final_tam[$i] = $tam[$i];
						#store all the tam of all interpretation in $final_tam
					}
					else
					{
						$final_tam[$i] = 0;
					}
				}
			}
			elsif($leaf_tag=~/^VAUX/ or $leaf_tag=~/PSP/)
			{
				$flag=1;
				my $word1=&get_field($leaf,2,$sent);
#print "LEAF TAG--$leaf_tag--$word1\n";
				push(@remove,$leaf);
				$fs = &get_field($leaf, 4,$sent);
				$fs_array = &read_FS($fs,$sent);
				@tam = &get_values("vib", $fs_array);
				@lex = &get_values("lex", $fs_array);
				push(@_leaf,$leaf);
				my $root = $lex[0];
				my $tam_t = "";
				if($tam[0] ne "" and $tam[0] ne "`" and $tam[0] ne "0" and $tam[0] ne $root)
				{
					$tam_t = $tam[0];
					$final_tam_aux = $final_tam_aux."_".$root."+".$tam_t;
				}
				else
				{
					$tam_t = "0";
					$final_tam_aux = $final_tam_aux."_".$root;
				}
			}
			elsif($leaf_tag eq 'NEG' and $verb_leaf_present == 1)
			{
				$neg = &get_field($leaf, 2,$sent);

				push(@remove,$leaf);
				$flag=1;
				$fs = &get_field($leaf, 4,$sent);
				$fs_array = &read_FS($fs,$sent);
				@tam = &get_values("vib", $fs_array);
				@lex = &get_values("lex", $fs_array);
				push(@_leaf,$leaf);
				my $root = $lex[0];
				my $tam_t = "";
				if($tam[0] ne "" and $tam[0] ne "`" and $tam[0] ne "0" and $tam[0] ne $root)
				{
					$tam_t = $tam[0];
					$final_tam_aux = $root."+".$tam_t;
				}
				else
				{
					$tam_t = "0";
				
					$final_tam_aux = "";
					$final_tam_aux = $root;
				}
			}
		}
		
		$fs_head = &get_field($parent, 4,$sent);
		$fs_head_array = &read_FS($fs_head,$sent);
		my @num,@gen,@per;
#print "-->",$#_leaf,"\n";	
		if($#_leaf>0)	
		{
			my $fs1 = &get_field($_leaf[-1], 4,$sent);
			my $fs2 = &get_field($_leaf[-2], 4,$sent);

			$fs_array1=&read_FS($fs1,$sent);
			$fs_array2=&read_FS($fs2,$sent);
			@num = &get_values("num", $fs_array1,$sent);
			@per = &get_values("per", $fs_array1,$sent);
			@gen = &get_values("gen", $fs_array2,$sent);
		}
		if($#_leaf==0)	
		{
			my $fs1 = &get_field($_leaf[-1], 4,$sent);
			my $pos1 = &get_field($_leaf[-1], 3,$sent);
			if($pos1 eq "VAUX" or $pos1 eq "PSP")
			{
			$fs_array1=&read_FS($fs1,$sent);
			@num = &get_values("num", $fs_array1,$sent);
			@per = &get_values("per", $fs_array1,$sent);
			}
		}
		for(my $i = 0; $i < scalar(@final_tam); $i++)
		{
			$tam_new[0] = $final_tam[$i]."$final_tam_aux";
			if($neg ne "")
			{
				$tam_new[0] = "$final_tam_aux"."_".$final_tam[$i];
			}
			#print "gen @gen[0]--num $num[0]---per $per[0]\n";

			&update_attr_val_2("vib", \@tam_new, $fs_head_array->[$i],$sent);
#print "@num[0]--@per[0]--@gen[0]\n";
			if(@gen[0] ne "")
			{
				&update_attr_val_2("gen", \@gen, $fs_head_array->[$i],$sent);
			}
			if(@num[0] ne "")
			{	
				&update_attr_val_2("num", \@num, $fs_head_array->[$i],$sent);
			}
			if(@per[0] ne "")
			{
				&update_attr_val_2("per", \@per, $fs_head_array->[$i],$sent);
			}
		}

		if($verb_leaf_present == 1 and $flag==1)
		{
			$string_head = &make_string($fs_head_array,$sent);
			&modify_field($parent, 4, $string_head,$sent);
		}
		delete @num[0..$#remove];
		delete @per[0..$#remove];
		delete @gen[0..$#remove];
	}
	my @sort_remove=sort{$a <=> $b} @remove;
	my $delete=0;
	foreach (@sort_remove)
	{	
		&delete_node($_-$delete,$sent);
		$delete++;
	}
	delete @remove[0..$#remove];
	delete @sort_remove[0..$#remove];

	#print "after vib comp--\n";
	#&print_tree();
}
1;
