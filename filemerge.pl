use strict;
use 5.10.0;

my $separator = "### Untracked files ###";

open(LS,  "<", shift @ARGV);

my %ls;
while(<LS>)
{
	chomp;
	$ls{$_} = 0;
}

while(<>)
{
	last if /$separator/;
	chomp;
	if(my ($fn) = m|(^[\w/]+\.\w+)|){
		s/^/MISSING: / unless defined $ls{$fn};
		$ls{$fn} = 1;
	}
	say;
}

say "\n\n$separator\n\n";

foreach my $fn (keys %ls){
	say "$fn" if $ls{$fn} == 0;
}
