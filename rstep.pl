use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];
$basename =~ s/\.R$//;

### Read and parse
my $f = <>;

# Sources
my (%sources);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/source.*"(.*?)"//){
	$sources{$1}=0;
}
if (%sources){
	say "$basename.reqs: ", join " ", keys %sources;
	say"";
}

# Loads
my (%loads);
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;
while ($f =~ s/load.*"(.*?)"//){
	$loads{$1}=0;
}
if (%loads){
	say "$basename.reqs: ", join " ", map {s|.RData$|.Rout|; $_} keys %loads;
	my @deps = map {s|.RData$|.reqs|; $_} keys %loads;
	say "$basename.reqs: ", join " ", @deps if @deps;
	say"";
}

## Needed to _override_ more probing rules in stepR.mk
say "$basename.reqs: ;", 'touch $@', "\n";

