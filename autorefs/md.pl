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

# Make mdrecs for each RXREF; replace RXREF with appropriate text
foreach (keys %rx){
	my $target = "$bib/$_.mdrec";
	my $txt = `cat $target`;
	$f =~ s/\[RXREF:$_\]/$txt/;
}

$f =~ s/\[RXPOINT:[^\]]*]//g;

say $f;
