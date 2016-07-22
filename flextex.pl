use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];
$basename =~ s/\.tex$//;

### Read and parse
my $f = <>;
my (%inputs, %packages, %graphics, %bibs, %dirs);

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
while ($f =~ s/\\bibliography\s*{(.*?)}//){
	my @biblist = split /,\s*/, $1;
	@biblist= map {s/\.bib$//; s/$/.bib/; $_} @biblist;
	foreach (@biblist){
		$bibs{$_}=0;
	}
}

### Write makefile stuff)
say "$basename.aux: $basename.tex $basename.reqs; ", '$(latex) ', $basename;
say "$basename.reqs: ;", 'touch $@', "\n";

if (%graphics){
	say "$basename.reqs: ", join " ", keys %graphics, "\n";
}

if (%inputs){
	say "$basename.reqs: ", join " ", keys %inputs;
	my @deps = map {s|.tex$|.reqs|; $_} keys %inputs;

	# Some issue from newlatex about crossing directories; maybe solved by hiding at the file level?
	# @deps = grep(!/\//, @deps); 
	say "$basename.reqs: ", join " ", @deps if @deps;
	say"";
}

if (%bibs){
	say "$basename.reqs: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs, "\n";
}

foreach(keys %inputs, keys %packages, keys %graphics, keys %bibs)
{
	s|/*[^/]*$||;
	$dirs{$_} = $_ if $_;
}

say "# $basename.tex: ", join " ", keys %dirs;
