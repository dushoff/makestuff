use strict;
use 5.10.0;

while(<>){
	last if /-------------------------------/;
	## Space and comments
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	if (s/^[0-9]+\.\s*//){
		my $name = $_;
		$name =~ s/\W.*//;
		say "screendirs += $name"
	}

	## URL specifications
	if (my ($d, $u) = /([^:]*):\s*(https:[^\s]*)/){
		say "clonedirs += $d";
		say "$d: url=$u";
	}
}
