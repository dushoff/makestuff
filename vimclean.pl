use strict;
use 5.10.0;

my $vr = `vim -r 2>&1`;
## say $vr;

foreach my $f (split /\n[0-9]+\./, $vr){
	my $fn = $f;
	$fn =~ s/\s*//;
	$fn =~ s/\s.*//s;
	next if $fn =~ /modified: yes/;
	next if $fn =~ /still running/;
	unlink $fn;
}
