use strict;
use 5.10.0;

my $dvar = "screendirs";

while(<>){
	$dvar = "otherdirs" if /-------------------------------/;
	## Space and comments
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	if (s/^[0-9]+\.\s*//){
		my $name = $_;
		$name =~ s/\W.*//;
		say "$dvar += $name"
	}

	## Accumulate listdirs
	if (my ($d) = /([\w]*):/) {
		say "listdirs += $d";
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
