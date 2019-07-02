use strict;
use 5.10.0;

undef $/;

my $f = <>;
$f =~ s/^[*][\s*]*$//s;

say length($f);

