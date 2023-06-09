use strict;
use 5.10.0;

$/ = "";

my %tags;
my @tags;
my @recs;

## Go through records delimited as paragraphs, make a hash for each
## Keep track of the first time you see each tag
## Lines without tags are tagged by line number within record
while(<>){
	my %fields;
	my @lines = split /\n/, $_;
	for my $r (0..$#lines){
		$_ = $lines[$r];
		s/^/$r: / unless /^\s*\w*:/;
		my ($t, $f) = /^\s*(\w*):\s*(.*)/;
		$fields{$t} = $f;
		## say "$t: $f";
		unless(defined($tags{$t})){
			$tags{$t} = 0;
			push @tags, $t;
		}
	}
	push @recs, \%fields;
}

## Print a header row with tags ordered by when you saw them
foreach (@tags){
	print "$_\t";
}
say "";

foreach (@recs){
	my %fields = %{$_};
	foreach (@tags){
		print "$fields{$_}" if defined $fields{$_};
		print "\t";
	}
	say "";
}

