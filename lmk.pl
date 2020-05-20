use strict;
use 5.10.0;

## dvar is for numbered directories
## the early ones are alled
## all of them are ignored
## Accumulate all directories?; only accumulate screendirs
## above the break
## Make sure to ignore at the root
my $dvar = "screendirs";
my %listdirs;

while(<>){
	$dvar = "otherdirs" if /-------------------------------/;
	## Space and comments
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	## They don't necessarily need auto-rules (so don't need colons)
	if (s/^[0-9]+\.\s*//){
		my $name = $_;
		$name =~ s/[\s:].*//;
		say "$dvar += $name";
		say "$name/%: $name" if $name =~ s|/.*||;
	}

	## Accumulate listdirs
	if (my ($d) = /([\w]*):/) {
		die "multiple rules for $d on line $." if defined $listdirs{$d};
		$listdirs{$d} = 0;
	}

	## URL specifications
	if (my ($d, $u) = /([^:]*):.*(https:[^\s]*)/){
		say "$d: url=$u";
	}

	## legacy specifications
	if (my ($d, $u) = /([^:]*):.*(\.\.[^\s]*)/){
		say "$d: old=$u";
	}
}

say "listdirs = " . join " ", keys %listdirs;
