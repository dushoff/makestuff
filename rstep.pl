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
while ($f =~ s/\<source\s*\(\s*"(.*?)"//){
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
while ($f =~ s/\<read\s*\(\s*"(.*?)"//){
	$loads{$1}=0;
}
if (%loads){
	say "$basename.rdeps: ", join " ", keys %loads;
	say"";
}
