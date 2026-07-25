use strict;
use 5.10.0;
use Env;

my $delim = "## content from makestuff";
my $head = "## edited content";

if (open(my $fh, '<', '.gitignore')) {
	while (my $line = <$fh>) {
		last if /$delim/;
		say $head if $.==1;
	}
	close $fh;
}

say $delim;
my $ignore = $ENV{Ignore};
$ignore =~ s/\s+/\n/g;
say $ignore;
