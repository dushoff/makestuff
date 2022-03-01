## Brand new and needs lots of work 2021 Sep 09 (Thu)
## make a qw list of exclusion patterns maybe
use strict;
use 5.10.0;

undef $/;
my %files;
my @files;

### Read and parse
my $f = <>;
my @f = split /[\s[\]({})]+/, $f;

my @ext = qw(png html jpg jpeg gif pdf);

## Need to do this by line and look for ## and rpcall ☹
## Look for words that look like files
foreach my $w (@f){
	next if $w =~ /https*:/;
	next unless $w =~ /\w/;
	foreach my $e (@ext){
		if ($w=~/\.$e$/i){
			push @files, $w unless defined $files{$w};
			$files{$w} = 0;
		}
	}
}

say "dmdeps: " . join " ", @files
