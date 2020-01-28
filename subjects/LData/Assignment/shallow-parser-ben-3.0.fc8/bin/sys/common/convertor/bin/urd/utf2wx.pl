
sub utf2wx
{	
	$path=@_[0];
	$file=@_[1];
	$output=@_[2];

	system("$path/bin/urd/uniconv -decode utf-8 -encode ucs-2-be -in $file -out jnk");
	system("$path/bin/urd/u2r.exe < jnk > $output");
	system("rm -f jnk");
};
1;
