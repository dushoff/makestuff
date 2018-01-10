use strict;
use 5.10.0;
use Env;

say "## content from makestuff";
my $ignore = $ENV{Ignore};
$ignore =~ s/\s+/\n/g;
say $ignore;
