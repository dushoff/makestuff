use strict;
use 5.10.0;

my $untrack_string = "\n### Untracked files ###\n";

open(LS,  "<", shift @ARGV);

## Record files from file list
my %ls;
while(<LS>)
{
	chomp;
	next unless /[.]/;
	$ls{$_} = 0;
}

## Look for filenames in md file; note them as present or missing
## filename should be the first "word" thing on the line, and should have a .
## Directories are confusing me now
## Use a single quote to "escape" for files not in target directory
while(<>)
{
	last if /$untrack_string/;
	chomp;
	s/MISSING[^:]*: //;
	if(my ($fn) = m|^[\s*>#"*]*([\w/.]+\.\w+)|){
		s/[^\s#*]/MISSING: $&/ unless defined $ls{$fn};
		$ls{$fn} = 1;
	}
	say;
}

## Print out things not noted as present
my $sep=0;
foreach my $fn (keys %ls){
	if ($ls{$fn} == 0){
		say $untrack_string unless $sep++;
		say "* $fn";
		## $fn =~ s|.*(^[\w/]+\.\w+).*|$1|;
		## say "$fn\n";
	}
}
