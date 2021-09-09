## Brand new and needs lots of work 2021 Sep 09 (Thu)
## make a qw list of exclusion patterns maybe
use strict;
use 5.10.0;

undef $/;
my %files;

### Read and parse
my $f = <>;
my @f = split /[\s[\]({})]+/, $f;

my @ext = qw(png html jpg jpeg gif pdf);

## Look for words that look like files
foreach my $w (@f){
	next if $w =~ /https*:/;
	next unless $w =~ /\w/;
	foreach my $e (@ext){
		$files{$w} = 0 if $w=~/\.$e$/i;
	}
}

say "dmdeps: " . join " ", sort keys %files
