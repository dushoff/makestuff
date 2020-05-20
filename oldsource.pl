use strict;
use 5.10.0;

undef $/;

my @f = split /\n/, <>;

foreach (@f){
	next unless my ($w) = /^[0-9]+[.]\s*\w*:\s*(\.\.\S*)/;
	next if /https:/;
	my $fn = "$w/.git/config";
	next unless (-e $fn);
	my $url = `grep url $fn`;
	$url =~ s/.*url =//;
	$url =~ s/\s*$//;
	s/:/: $url/;
}

say join "\n", @f;
