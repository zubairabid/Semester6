#! /usr/bin/perl

# ISCII Devanagari to Unicode UTF-8 converter
# Copyright Andrew Dunbar, 2001
# Consider this code to be under GPL but do with it what you will.

use strict;

my %devanagari = (
	"\xa1" => 'ँ',	# chandrabindu
	"\xa1\xe9" => 'ॐ',	# om
	"\xa2" => 'ं',	# anuswar
	"\xa3" => 'ः',	# visarg
	"\xa4" => 'अ',
	"\xa5" => 'आ',
	"\xa6" => 'इ',
	"\xa6\xe9" => 'ऌ',	# &#2316; letter vocalic l
	"\xa7" => 'ई',
	"\xa7\xe9" => 'ॡ',	# &#2401; letter vocalic ll
	"\xa8" => 'उ',
	"\xa9" => 'ऊ',
	"\xaa" => 'ऋ',
	"\xaa\xe9" => 'ॠ',	# &#2400; letter vocalic rr
	"\xab" => 'ऎ',
	"\xac" => 'ए',
	"\xad" => 'ऐ',
	"\xae" => 'ऍ',
	"\xaf" => 'ऒ',
	"\xb0" => 'ओ',
	"\xb1" => 'औ',
	"\xb2" => 'ऑ',
	"\xb3" => 'क',
	"\xb3\xe9" => 'क़',	# &#2392 letter qa
	"\xb4" => 'ख',
	"\xb4\xe9" => 'ख़',	# &#2393 letter khha
	"\xb5" => 'ग',
	"\xb5\xe9" => 'ग़',	# &#2394 letter ghha
	"\xb6" => 'घ',
	"\xb7" => 'ङ',
	"\xb8" => 'च',
	"\xb9" => 'छ',
	"\xba" => 'ज',
	"\xba\xe9" => 'ज़',	# &#2395; letter za
	"\xbb" => 'झ',
	"\xbc" => 'ञ',
	"\xbd" => 'ट',
	"\xbe" => 'ठ',
	"\xbf" => 'ड',
	"\xbf\xe9" => 'ड़',	# &#2396; letter dddha
	"\xc0" => 'ढ',
	"\xc0\xe9" => 'ढ़',	# &#2397; letter rha
	"\xc1" => 'ण',
	"\xc2" => 'त',
	"\xc3" => 'थ',
	"\xc4" => 'द',
	"\xc5" => 'ध',
	"\xc6" => 'न',
	"\xc7" => 'ऩ',
	"\xc8" => 'प',
	"\xc9" => 'फ',
	"\xc9\xe9" => 'फ़',	# &#2398; letter fa
	"\xca" => 'ब',
	"\xcb" => 'भ',
	"\xcc" => 'म',
	"\xcd" => 'य',
	"\xce" => 'य़',
	"\xcf" => 'र',
	"\xd0" => 'ऱ',
	"\xd1" => 'ल',
	"\xd2" => 'ळ',
	"\xd3" => 'ऴ',
	"\xd4" => 'व',
	"\xd5" => 'श',
	"\xd6" => 'ष',
	"\xd7" => 'स',
	"\xd8" => 'ह',
	"\xd9" => '‍',	# ISCII INVisible -> Unicode ZWJ
	"\xda" => 'ा',
	"\xdb" => 'ि',
	"\xdb\xe9" => 'ॢ',	# &#2402; vowel sign vocalic l
	"\xdc" => 'ी',
	"\xdc\xe9" => 'ॣ',	# &#2403; vowel sign vocalic ll
	"\xdd" => 'ु',
	"\xde" => 'ू',
	"\xdf" => 'ृ',
	"\xdf\xe9" => 'ॄ',	# &#2372; vowel sign vocalic rr
	"\xe0" => 'ॆ',
	"\xe1" => 'े',
	"\xe2" => 'ै',
	"\xe3" => 'ॅ',
	"\xe4" => 'ॊ',
	"\xe5" => 'ो',
	"\xe6" => 'ौ',
	"\xe7" => 'ॉ',
	"\xe8" => '्',	# halant
	"\xe9" => '़',	# nukta
	"\xea" => '।',	# full stop / viram
	"\xea\xe9" => 'ऽ',	# &#2365; sign avagraha
	"\xea\xea" => '॥',	# &#2405; double danda (ARD)
	"\xeb" => '?',
	"\xec" => '?',
	"\xed" => '?',
	"\xee" => '?',
	"\xef" => '?',		# attribute
	#"\xf0" => '?',		# extension
	"\xf0\xb8" => '॒',	# &#2386; stress sign anudatta (uses EXT)
	"\xf0\xbf" => '॰',	# &#2416; abbreviation sign (uses EXT)
	"\xf1" => '०',
	"\xf2" => '१',
	"\xf3" => '२',
	"\xf4" => '३',
	"\xf5" => '४',
	"\xf6" => '५',
	"\xf7" => '६',
	"\xf8" => '७',
	"\xf9" => '८',
	"\xfa" => '९',
	"\xfb" => '?',
	"\xfc" => '?',
	"\xfd" => '?',
	"\xfe" => '?',
);

my $b = undef;
my $stash = '';
my $out = '';

while ((my $c = getc) ne undef) {
	my $utf8 = undef;
	
	# nukta combines with previous character
	if ($c eq "\xe9") {
		$out = $devanagari{$b.$c};
		$out = $stash . $devanagari{$c} unless $out;
		$stash = '';
	# combind two ASCII dandas into a Unicode double danda
	} elsif ($c eq "\xea" && $b eq "\xea") {
		$out = $devanagari{$b.$c};
		$stash = '';
	# EXT combines with next character
	} elsif ($c eq "\xf0") {
		$out = $stash;
		$stash = '';
	# regular ISCII range
	} elsif ($c =~ /[\xa1-\xfe]/) {
		if ($b eq "\xf0") {
			$out = $devanagari{$b.$c};
		} else {
			$out = $stash;
			$stash = $devanagari{$c};
		}
	# ASCII range etc
	} else {
		$out = $stash . $c;
		$stash = '';
	}

	print $out;

	$b = $c;
}

print $stash;

