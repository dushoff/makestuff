use strict;
use 5.10.0;

my $untrack_string = "### Untracked files ###";

open(LS,  "<", shift @ARGV);

## Record files from file list
my %ls;
while(<LS>)
{
	chomp;
	next unless /[.]/;
	$ls{$_} = 0;
}

## say "There: " . join "; ", keys %ls;

## Look for filenames in md file; note them as present or missing
## filename should be the first "word" thing on the line, and should have a .
## Use a single quote to "escape" for files not in target directory
## Try to remove a the first markdown [] tag (not looking for ! yet) 2021 Sep 14 (Tue)
while(<>)
{
	last if /$untrack_string/;
	chomp;
	s/MISSING[^:]*: //;
	s/\[[^[]*\]\(//; ## Trim an apparent markdown description
	# Don't ignore files in subdirectories [/]
	# Otherwise it will work only for index
	if(my ($fn) = m|^[\s>#"*/]*([\w.-]+\.\w+)|){
		s/[^\s#*]/MISSING: $&/ unless defined $ls{$fn};
		$ls{$fn} = 1;
	}
	say;
}

## Not working for subdirectories right now? 2022 Nov 22 (Tue)

## say "Here: " . join "; ", keys %ls;
## while (my ($k, $v) = each %ls){ say "$k: $v"; }

## Print out things not noted as present
my %untracked;
foreach my $fn (keys %ls){
	$untracked{$fn} = 0 if $ls{$fn} == 0;
}

my $nun = keys %untracked;

if ($nun>0) {
	say "\n$untrack_string ($nun)\n";
	foreach my $fn (keys %untracked){
		say "* $fn";
	}
}
