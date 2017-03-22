## Horrible, wet code.
## Should really have an input table, and a two-level hash
## But I probably never will

use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];
$basename =~ s/\.R$//;

### Read and parse
my $f = <>;
	say "";

# Sources
my (%sources);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/\bsource\s*\(\s*"(.*?)"//){
	$sources{$1}=0;
}
if (%sources){
	say "$basename.Rout $basename.rdeps: "
		, join " ", keys %sources
		, join " ", map {s|.R$|.rdeps|; $_} keys %sources;
	say "";
}

# Loads
my (%loads);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/\bload\s*\(\s*"(.*?)"//){
	$loads{$1}=0;
}
if (%loads){
	say "$basename.rdeps: ", join " ", keys %loads;
	say"";
}

# Reads
my (%reads);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/\bread\.\w+\s*\(\s*"(.*?)"//){
	$reads{$1}=0;
}
if (%reads){
	say "$basename.rdeps: ", join " ", keys %reads;
	say"";
}

# Writes
my (%writes);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/\bwrite\.\w+\s*\(\s*"(.*?)"//){
	$writes{$1}=0;
}
if (%writes){
	say "join " ", keys %writes, ": $basename.Rout ;";
	say"";
}
