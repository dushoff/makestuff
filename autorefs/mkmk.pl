use strict;
use 5.10.0;

my $base = 'bibdir/';
my $recname = shift(@ARGV);

undef $/;
my $f = <>;

my %rx;

# Find unique RXREFs
foreach ($f =~ /\[RXREF:([^\]]*)\]/g){
	$rx{$_}=1;
}

my @stems = sort keys %rx;
@stems = grep {s/^/$base/} @stems;

say "$recname: " .  join ".$recname ", @stems, "";
say "$recname: " .  join ".$recname ", @stems, "";
