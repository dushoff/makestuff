use strict;
use 5.10.0;
undef $/;

my $bib = "bibdir/";
die "bib undefined" if (!$bib);

my $f = <>;

my %rx;

# Find unique RXREFs
foreach ($f =~ /\[RXREF:([^\]]*)\]/g){
	$rx{$_}=1;
}

foreach (keys %rx){
	my $target = "$bib/$_.refrec";
	say `cat $target`;
}
