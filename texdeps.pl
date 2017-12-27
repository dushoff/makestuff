use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];

$basename =~ s/\.tex$//;
my $target =  ".texdeps/$basename.out";

### Read and parse
my $f = <>;
my (%inputs, %packages, %graphics, %bibs, %dirs);
$f =~ s/.*%.*no_texdeps.*//;

# Inputs (add include!)
$f =~ s/^%.*//;
$f =~ s/\n%.*//g;
while ($f =~ s/\\input\s*{(.*?)}//){
	$inputs{$1}=0;
}

## packages are tracked only for their directory
while ($f =~ s/\\usepackage\s*{(.*?)}//){
	my @packlist = split /,\s*/, $1;
	foreach (@packlist){
		$packages{$_}=0;
	}
}

## Graphics (only one method so far)
while ($f =~ s/\\includegraphics\s*{(.*?)}//){
	$graphics{$1}=0;
}

# Not sure what the parsing issue was here
while ($f =~ s/\\includegraphics\s*\[[^\]]*]\s*{(.*?)}//){
	$graphics{$1}=0;
}

## Bib
while ($f =~ s/\\(?:bibliography|addbibresource)\s*{(.*?)}//){
	my @biblist = split /,\s*/, $1;
	@biblist= map {s/\.bib$//; s/$/.bib/; $_} @biblist;
	foreach (@biblist){
		$bibs{$_}=0;
	}
}

### Write makefile stuff

say "$target: ; touch \$@";
say"";

if (%graphics){
	say "$target: ", join " ", keys %graphics, "\n";
	say"";
}

if (%inputs){
	say "$target: ", join " ", keys %inputs;
	my @deps = map {s|.tex$|.deps|; $_} keys %inputs;

	# Some issue about crossing directories; maybe solved now? 
	# @deps = grep(!/\//, @deps); 
	say "$target: ", join " ", @deps if @deps;
	say"";
}

if (%bibs){
	say "$target: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs, "\n";
}

foreach(keys %inputs, keys %packages, keys %graphics, keys %bibs)
{
	s|/*[^/]*$||;
	$dirs{$_} = $_ if $_;
}

# Not clear why this was suppressed
say "$target: ", join " ", keys %dirs;
