use strict;
use 5.10.0;

while (<>){
	chomp;
	next unless (
		/(R --vanilla.*rtmp)/
	);
	my $com=$1;
	$com =~ s/rtmp/Rout/;
	say $com;
}

