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

my $sep=0;
foreach my $fn (keys %ls){
	if ($ls{$fn} == 0){
		say $separator unless $sep++;
		say $fn;
		$fn =~ s|.*(^[\w/]+\.\w+).*|$1|;
		## say "$fn\n";
	}
}
