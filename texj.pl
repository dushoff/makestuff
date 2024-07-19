use strict;
use 5.10.0;

undef $/;

my $basename = $ARGV[0];

$basename =~ s/\.tex$//;
my $target =  "$basename.tex.deps";
my $ftarget =  "$basename.tex.files";
my $files =  $basename."Files";

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
print "$target: | ", join " ", keys %dirs, "\n\n" if %dirs;

## Pictures
if (%graphics){
	say "$files += ", join " ", keys %graphics, "\n";
	say"";
}

## Inputs
if (%inputs){
	say "$files += ", join " ", keys %inputs;

	## 2024 Jul 19 (Fri) Tex dependencies across directories
	##  works well for texknit/ projects
	## But doing it manually works well also …
	## Suppressing for now (using grep line below)
	my @deps = keys %inputs;
	@deps = grep(!/\//, @deps); 
	if (@deps){
		say "$files += " . join " ", map {s|.tex$|.tex.makedeps|; $_} @deps;
	}
	say"";
}

## Bib stuff
if (%bibs){
	say "$target: $basename.bbl";
	say "$basename.bbl: " . join " ", keys %bibs;
	## say "$target: " . join " ", keys %bibs, "\n";
	say"";
}

say "$target: \$($files)";
say "$ftarget: \$($files)";
