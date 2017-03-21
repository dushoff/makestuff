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
while ($f =~ s/source.*"(.*?)"//){
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
while ($f =~ s/load.*"(.*?)"//){
	$loads{$1}=0;
}
if (%loads){
	say "$basename.rdeps: ", join " ", map {s|.RData$|.RData|; $_} keys %loads;
	say"";
}
