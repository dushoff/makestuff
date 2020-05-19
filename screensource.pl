use strict;
use 5.10.0;

undef $/;

my @f = split /\n/, <>;

foreach (@f){
	next unless my ($w) = /^[0-9]+[.]\s*(\w*):/;
	next if /https:/;
	my $fn = "$w/.git/config";
	next unless (-e $fn);
	my $url = `grep url $fn`;
	$url =~ s/.*url =//;
	s/:/: $url/;

}

say join "\n", @f;
