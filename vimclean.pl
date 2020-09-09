use strict;
use 5.10.0;

my $vr = `vim -r 2>&1`;
## say $vr;

my @f  = split /\n[0-9]+\./, $vr;
shift @f;
foreach my $f (@f){
	my $fn = $f;
	$fn =~ s/\s*//;
	$fn =~ s/\s.*//s;
	next if $f =~ /modified: yes/i;
	next if $f =~ /still running/;
	unlink $fn;
}
