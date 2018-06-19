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
		$inits =~ s/(.)/$1. /g;
		$_ = "$surname, $inits";
	}
}

my $author = join " and ", @author;
$author =~ s/\s*$//;

my $tag = $rec{TAG};

print '@';
print "article {$tag,\n";
print "author = {$author},\n";
print "year = {$rec{DP}},\n";
print "title = {{$rec{TI}}},\n";
print "journal = {$rec{TA}},\n";
print "id = {$rec{AID}},\n";
unless ($rec{VI} eq "Not found"){
	print "volume = {$rec{VI}},\n";
	print "pages = {$rec{PG}},\n";
}
print "pmid = {$rec{PMID}}}\n";
