use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];

$basename =~ s/\.tex$//;

### Read and parse
my $f = <>;
my (%inputs, %graphics, %bibs);
$f =~ s/.*%.*no_texdeps.*//;

# input/include
$f =~ s/^%.*//;
$f =~ s/\n%.*//g;
while ($f =~ s/\\input\s*{(.*?)}//){
	$inputs{$1}=0;
}
while ($f =~ s/\\include\s*{(.*?)}//){
	$inputs{$1}=0;
}

## Graphics
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

######################################################################
### Write rules

## Use order-only as of 2023 Nov 08 (Wed)
## Directories
## Needs to be above any dependencies that might look in the directories
## makehere and makethere would need to be in your own make file
## Only first-level subdirectories should be handled here
my (%dirs);
foreach(keys %inputs, keys %graphics, keys %bibs)
{
	s|/*[^/]*$||;
	s|/.*||;
	$dirs{$_} = $_ if $_;
}
if (%dirs){
	my $ddep = join " ", keys %dirs;
	say "$basename.tex.dirs: $ddep";
	say"";
}

## Pictures
if (%graphics){
	my $gdep = join " ", keys %graphics;
	say "$basename.tex.pix: $gdep";
	say"";
}

## Inputs
if (%inputs){
	my $idep = join " ", keys %inputs;
	say "$basename.tex.inputs: $idep";
	my $iddep = join " ", map {s/$/.deps/; $_} keys %inputs;
	say "$basename.tex.inputs: $iddep";
	my $ifdep = join " ", map {s/$/.files/; $_} keys %inputs;
	say "$basename.tex.inputs: $ifdep";
	say"";
}

## Bib stuff
if (%bibs){
	say "$basename.biblio: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs;
	say"";
}

