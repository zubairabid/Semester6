
sub utf2wx
{	
	$path=@_[0];
	$file=@_[1];
	$output=@_[2];
	system("perl $path/bin/mar/unicode-wx.pl $file > .tmp.num");
	system("perl $path/bin/mar/utf82iscii.pl < .tmp.num > .tmp.iscii");
	system("$path/bin/mar/i8_wx/d8_ra_wp_r.exe < .tmp.iscii > $output");
	system("rm -f .tmp.iscii");
	system("rm -f .tmp.num");
};
1;
