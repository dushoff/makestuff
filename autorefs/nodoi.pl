use strict;
use 5.10.0;
undef $/;

my ($fn) = @ARGV;
my $f = <>;

$f =~ s/doi:/digital_id:/g;

print $f;
