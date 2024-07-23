use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];

## $basename =~ s/\.tex$//;
my $target =  "$basename.deps";
my $ftarget =  "$basename.files";

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
	say "$target: $ddep";
	say "$ftarget: $ddep";
	say"";
}

## Pictures
if (%graphics){
	my $gdep = join " ", keys %graphics;
	say "$target: $gdep";
	say "$ftarget: $gdep";
	say"";
}

## Inputs
if (%inputs){
	my $idep = join " ", keys %inputs;
	say "$target: $idep";
	say "$ftarget: $idep";
	my $iddep = join " ", map {s/$/.deps/; $_} keys %inputs;
	say "$target: $iddep";
	my $ifdep = join " ", map {s/$/.files/; $_} keys %inputs;
	say "$ftarget: $ifdep";
	say"";
}

## Bib stuff
if (%bibs){
	say "$target: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs;
	say"";
}

