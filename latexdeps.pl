use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];
$basename =~ s/\.tex$//;

my $f = <>;
my (%inputs, %packages, %graphics, %bibs, %dirs);

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

while ($f =~ s/\\includegraphics\s*{(.*?)}//){
	$graphics{$1}=0;
}

while ($f =~ s/\\includegraphics\s*\[[^\]]*]\s*{(.*?)}//){
	$graphics{$1}=0;
}

while ($f =~ s/\\bibliography\s*{(.*?)}//){
	my @biblist = split /,\s*/, $1;
	@biblist= map {s/\.bib$//; s/$/.bib/; $_} @biblist;
	foreach (@biblist){
		$bibs{$_}=0;
	}
}

if (%inputs){
	say "$basename.tex: ", join " ", keys %inputs;
	# my @deps = map {s|^|.deps/|; s|$|.d|; $_} keys %inputs;
	my @deps = map {s|$|.deps|; $_} keys %inputs;
	@deps = grep(!/\//, @deps); 
	say "$basename.tex: ", join " ", @deps if @deps;
	say;
}

if (%graphics){
	say "$basename.tex: ", join " ", keys %graphics, "\n";
}

if (%bibs){
	say "$basename.pdf: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs, "\n";
}

foreach(keys %inputs, keys %packages, keys %graphics, keys %bibs)
{
	s|/*[^/]*$||;
	$dirs{$_} = $_ if $_;
}

say "# $basename.tex: ", join " ", keys %dirs;
