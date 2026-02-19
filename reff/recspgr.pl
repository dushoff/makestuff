use strict;
use 5.12.0;

$/ = "";

while(<>){
	my %rec;
	my $doi="";
	$doi=$1 if /([^\s]*)\s*\[doi\]/;
	my @fields = split /\n/, $_;
	for my $f (@fields){
		next unless my ($tag, $text) = $f =~ /^([\w]+)\s*:\s+(.*)/;
		push @{$rec{$tag}}, $text;
	}
	for my $tag (keys %rec){
		$rec{$tag} = join " | ", @{$rec{$tag}};
	}
	my $source = $rec{TA};
	if ($source =~ /medRxiv/){
		warn "SKIPPING medRxiv $rec{TI}";
		next;
	}

	my $pub = $rec{DP};
	$pub =~ s/\s.*//;

	say "AU: $rec{FAU}";
	say "TI: $rec{TI}";
	say "SO: $source";
	say "PUB: $pub";

	## Why was I making my own location; it pisses off some bib styles
	## push my @loc, $rec{VI} if defined $rec{VI};
	## push @loc, $rec{PG} if defined $rec{PG};
	## say "LOC: " . join ":", @loc;

	say "VI: $rec{VI}" if defined $rec{VI};
	say "PG: $rec{PG}" if defined $rec{PG};
	say "PMID: $rec{PMID}" if defined $rec{PMID};
	say "PMC: $rec{PMC}" if defined $rec{PMC};
	say "DOI: $doi" if defined $doi;
	say "AB: $rec{AB}" if defined $rec{AB};
	say "";
}


