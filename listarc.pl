use strict;
use 5.10.0;

my $proj=0;
while(<>){
	$proj++;
	s/^[0-9]+\./XX./;
	print;
}
