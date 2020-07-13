use strict;
use 5.10.0;

open(LS,  "<", shift @ARGV);

my %ls;
while(<LS>)
{
	chomp;
	$ls{$_} = 0;
}

while(<>)
{
	chomp;
	if(my ($fn) = m|(^[\w/]+\.\w+)|){
		s/^/MISSING: / unless defined $ls{$fn};
		$ls{$fn} = 1;
	}
	say;
}

foreach my $fn (keys %ls){
	say "UNTRACKED: $fn" if $ls{$fn} == 0;
}
