## Made from longtags, which was a Dushoff-curation thing
## Started in nserc folder 2025 Oct 25 (Sat)
use strict;
use 5.10.0;

$/ = "";

my %tags;
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
	my $tag = $fields{AU};
	$tag =~ s/\s.*//;
	my @pub = split /\s+/, $fields{PUB};
	$tag .= $pub[0];
	my @title =  split /\s+/, $fields{TI};
	@title = map {s/\W//g; $_} @title;
	@title = grep /..../, @title;
	$tag .= $title[0];

	## Don't add source so that we can see more conflicts
	## my @source =  split /\s+/, $fields{SO};
	## @source = grep /../, @source;
	## $#source = 1 if $#source > 1;
	## $tag .= join "", @source;
	$tag =~ tr/[A-Z]/[a-z]/;
	$tag =~ s/\W//g;

	## Don't die on conflict because not all can be avoided (e.g., erroneous WoS duplications!)
	warn "REPEATED tag $tag" if defined $tags{$tag};
	$tags{$tag} = 0;
	say "TAG: $tag";
	print;
}
