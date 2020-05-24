use strict;
use 5.10.0;

## Numbered directories _before_ the break go into screendirs
## Accumulate all directories?; only accumulate screendirs
## above the break
## Make sure to listdirs at the root
my %ruledirs;
my %listdirs;
my %parents;

while(<>){
	## Space and comments
	my $active = 1 .. /-------------------------/;
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	## They don't necessarily need auto-rules (so don't need colons)
	## screens after divider aren't screened, but are still listdirs
	if (s/^[0-9]+\.\s*//){
		my $name = $_;
		$name =~ s/[\s:].*//;
		$name =~ s|/$||;
		say "screendirs += $name" if $active;
		$listdirs{$name}=0;
		$parents{$name} = 0 if $name =~ s|/.*||;
	}

	## First word followed by colon is a rule
	## a ruledir is also a listdir
	if (my ($d, $l) = /^([\w]*)(:.*)/){
		die "multiple rules for $d on line $." if defined $ruledirs{$d};
		$ruledirs{$d} = 0;
		$listdirs{$d} = 0;

		## URL specifications
		if (my ($u) = /(https:[^\s]*)/){
			say "$d: url=$u";
		}

		## legacy specifications
		if (my ($u) = /(\.\.[^\s]*)/){
			say "$d: old=$u";
		}
	}
}

say "ruledirs = " . (join " ", keys %ruledirs);
say "listdirs = " . (join " ", keys %listdirs);
foreach (keys %parents){ say "$_/%: $_ ;"; }
