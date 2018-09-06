use strict;
use 5.10.0;

say "%.run.r: %.wrapR.r; \$(copy)";

my %runs;
while (<>){
	chomp;
	my ($f) =/.*"(.*)"/; 
	$runs{$f} = 0 if defined $f;
}
 
print "runs: ";
say join " ", keys(%runs);
