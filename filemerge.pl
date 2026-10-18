use strict;
use 5.10.0;

my $untrack_string = "### Untracked files ###";

## Suffixes of files never reported as untracked
my @ignore_suffixes = qw(
	pip time deps temp stamp log
	mirror puttime
	reff.bib repeat texdeps.mk
);
my $ignore_re = join "|", map {quotemeta} @ignore_suffixes;

open(LS,  "<", shift @ARGV);

## Record files from file list
my %ls;
while(<LS>)
{
	chomp;
	next unless /[.]/;
	next if /^tmp\./;
	next if /\.(?:$ignore_re)$/;
	$ls{$_} = 0;
}
## say "There: " . join "; ", keys %ls;

## exit(0);

## Look for filenames in md file; note them as present or missing
## filename should be the first "word" thing on the line, and should have a .
## Use a single quote to "escape" for files not in target directory
## Try to remove a the first markdown [] tag (not looking for ! yet) 2021 Sep 14 (Tue)
## Tried to make this target-safe 2026 Jul 25 (Sat)
#### Gave up because targets are there sometimes but not others.
my $ll;
while(<>)
{
	last if /$untrack_string/;
	chomp;
	s/MISSING[^:]*: //;
	s/\[[^[]*\]\(//; ## Trim an apparent markdown description
	# Don't ignore files in subdirectories [/]
	# Otherwise it will work only for index
	## % is a make-style wildcard (e.g., %.pip); never MISSING, and marks matching files as tracked
	if(my ($fn) = m|^[\s>#"*]*([/\w.%-]+\.\w+)|){
		if ($fn =~ /%/){
			(my $pat = quotemeta $fn) =~ s/\\%/.+/g;
			$ls{$_} = 1 foreach grep {/^$pat$/} keys %ls;
		} else {
			s/[^\s#*]/MISSING: $&/ unless (defined $ls{$fn} or (-e $fn));
		}
		$ls{$fn} = 1;
		## say "Tracked: $fn";
	}
	say;
	$ll = $_;
}

## Print out things not noted as present
my %untracked;
foreach my $fn (keys %ls){
	$untracked{$fn} = 0 if $ls{$fn} == 0;
}

my $nun = keys %untracked;

if ($nun>0) {
	say "" if $ll;
	say "$untrack_string ($nun)\n";
	foreach my $fn (keys %untracked){
		say "* $fn";
	}
}
