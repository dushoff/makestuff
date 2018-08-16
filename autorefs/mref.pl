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

say "$tag :: $author. $rec{TI}. $rec{TA} $rec{VI}:$rec{PG} ($rec{DP}).";
