use strict;
use 5.10.0;
undef $/;

my $base = 'bibdir/';

my $f = <>;

my %rx;

# Find unique RXREFs
foreach ($f =~ /\[RXREF:([^\]]*)\]/g){
	$rx{$_}=1;
}

my @stems = sort keys %rx;
@stems = grep {s/^/$base/} @stems;

say "mdrec: " .  join ".mdrec ", @stems, "";
