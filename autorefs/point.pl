use strict;
use 5.10.0;
undef $/;

my $f = <>;

foreach ($f =~ /\[RXPOINT:([^\]]*)\]/g){
	say "$_";
}
