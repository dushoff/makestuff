## If a ¶ has a figure link, print it _after_ the preceding ¶
use strict;
use 5.10.0;

my $pend = "";

$/ = "";

while (<>){
	if (/}!\[/){
		$pend = $_;
	} else
	{
		print;
		print $pend if $pend;
		$pend = "";
	}
}
