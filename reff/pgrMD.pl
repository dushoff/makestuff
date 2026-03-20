use strict;
use 5.10.0;

$/ = "";

my $pubmedbase = "https://pubmed.ncbi.nlm.nih.gov/";
my $pmcbase = "https://www.ncbi.nlm.nih.gov/pmc/articles/";
my $doibase = "https://doi.org/";
my $at = '@';

while(<>){
	my %fields;
	my $count;
	my @lines = split /\n/, $_;
	foreach my $ln (@lines){
		my ($t, $f) = $ln =~ /(\w*):\s*(.*)/;
		$count++ if $f;
		$fields{$t} = $f if $f;
	}
	next unless $count;

	say "$at$fields{TAG}";
	print "$fields{TI} ";
	my @au = split /\s*[|]+\s*/, $fields{AU};
	print join "; ", @au;
	say ".";
	say "$fields{SO}, $fields{PUB}.";
	## Would be possible to add LOC stuff from recsbib.pl

	say "* library/$fields{TAG}.pdf";
	say "* $pubmedbase$fields{PMID}" if defined $fields{PMID};
	say "* $pmcbase$fields{PMC}" if defined $fields{PMC};
	say "* $doibase$fields{DOI}" if defined $fields{DOI};

	say "\t$fields{AB}" if defined $fields{AB};

	say "";
}


