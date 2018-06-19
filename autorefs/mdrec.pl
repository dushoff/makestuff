use strict;
use 5.10.0;

my %rec;
while(<>){
	my ($key, $fields) = /([^:]*): *(.*)/ or die ("Illegal line $_");
	$rec{$key} = $fields;
}

# If no surname identified, we have a one-name author and we leave it alone.
my @author = split / #AND# /, $rec{FAU};
foreach (@author) {
	next if s/GROUP[: ]*//;
	my ($surname, $inits) = /(\w+.*?)\s*,\s*(.*?)\s*$/;
	if ($surname){
		$inits =~ s/[^A-Z]//g;
		$inits =~ s/(.)/$1/g;
		$_ = "$surname $inits";
	}
}

$rec{DP} =~ s/\s.*//;
$rec{TI} =~ s/[.\s]*$//;

my $author = join ", ", @author;
$author =~ s/\s*$//;

my $tag = $rec{TAG};

my $link;
$link = "https://www.ncbi.nlm.nih.gov/pubmed/$rec{PMID}"
	if defined $rec{PMID};
$link = $rec{UR} if defined $rec{UR};

## maclink currently seems to work with doi but not pubmed??
my $maclink;
if ($link){
	$maclink=$link;
	$maclink =~ s|https*://([^/]*)/|http://$1.libaccess.lib.mcmaster.ca/|;
}

print "_$tag:_ $author. [$rec{TI}]";
print "($link)" if $link; 
print " [(McMaster link)]($maclink)" if ($link && $link=~/dx.doi/);  
say ". $rec{TA} $rec{VI}:$rec{PG} ($rec{DP}).";
