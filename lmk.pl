use strict;
use 5.10.0;

my %listdirs; ## The main thing, they are alled, ignored and screened above the line
my %ruledirs; ## Things we can make by cloning (or sometimes moving)
my %knowndirs; ## Things we should recognize and ignore ## tagged with NOALL in the infile

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
		if(/#.*NOALL/){$knowndirs{$name}=0} else{$listdirs{$name}=0};
		my $top;
		while (($name, $top) = $name =~ m|(.*)/([^/]*)|){
			say "$name/$top: $name";
		}
	}

	## First word followed by colon is a rule
	## a ruledir is also a listdir
	if (my ($d, $l) = /^([\w]*)(:.*)/){
		die "repeated rule for $d on line $." if defined $ruledirs{$d};
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
say "knowndirs = " . (join " ", keys %knowndirs);
