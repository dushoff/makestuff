use strict;
use 5.10.0;

$/ = "";
my $art = '@article{';

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
	say "$art$fields{TAG}";
	say "\t, title = {{$fields{TI}}}";
	my @au = split /\s*[|]+\s*/, $fields{AU};
	my $aulist = join " and ", @au;
	say "\t, author={$aulist}";
	say "\t, journal = {$fields{SO}}";
	say "\t, volume = {$fields{VI}}" if defined $fields{VI};
	## arXiv papers have no pages; use the arXiv identifier instead
	$fields{PG} //= $1 if defined $fields{DOI} and $fields{DOI} =~ m|^10\.48550/arxiv\.(.*)|i;
	say "\t, pages = {$fields{PG}}" if defined $fields{PG};
	say "\t, year = $fields{PUB}";
	say "}\n";
}


