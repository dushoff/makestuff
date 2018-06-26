use strict;
use 5.10.0;

undef $/;

my $f = <>;

$f =~ s/.*<pre>//s;
$f =~ s|</pre>.*||s;
$f =~ s/\n([A-Z][A-Z0-9]*)\s*-\s*/%FIELD%$1: /g;

sub fill{
	my ($hp, $a, $b)=@_;

	$hp->{$a} = $hp->{$b} unless defined $hp->{$a};
	$hp->{$b} = $hp->{$a} unless defined $hp->{$b};
	unless (defined $hp->{$a}){
		say STDERR "Can't find $a or $b" unless defined $hp->{$a};
		$hp->{$b} = ["Not found"];
		$hp->{$a} = $hp->{$b};
	}
}

my %rec;

## Parse fields and string together repeat fields into arrays
foreach (split /%FIELD%/, $f){
	s/\s+/ /g;
	# print "Field: $_\n";
	next unless my($key, $field) = /^([A-Z][A-Z0-9]*): (.*)/;
	push @{$rec{$key}}, $field;
}

## Make an abbreviated author field from the standard author field
foreach my $n (@{$rec{AU}}){
	my ($sur, @giv) = split /\s+/, $n;
	foreach (@giv){
		s/(.).*/$1/;
	}
	push @{$rec{NAU}}, "$sur " . join "", @giv;
}

fill(\%rec, "FAU", "NAU");
fill(\%rec, "PY", "DP");
fill(\%rec, "PG", "DP");
fill(\%rec, "TA", "T2");
fill(\%rec, "VI", "VL");
fill(\%rec, "PG", "SP");

my $tag = substr($rec{AU}->[0], 0, 4);
$tag .= substr($rec{AU}->[1], 0, 4) if defined($rec{AU}->[1]);
$tag =~ s/[, ]*//g; # Removing trailing stuff from short author names
$tag =~ s/'/_/g; # Apostrophes choke bibtexml (and maybe others)
$tag .= substr($rec{DP}->[0], 2, 2);
$rec{TAG} = [$tag];

foreach (sort keys %rec){
	print "$_: ";
	print join " #AND# ", @{$rec{$_}};
	print "\n";
}

