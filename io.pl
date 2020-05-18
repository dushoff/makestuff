use strict;
use 5.10.0;

my $proj = 0;
while(<>){
	$proj += 100 if /-------------------------------/;
	if (/^[0-9]+\./){
		$proj++;
		s/^[0-9]+/$proj/;
	}
	print;
}
