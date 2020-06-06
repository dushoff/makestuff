use strict;
use 5.10.0;

my %listdirs; ## The main thing, they are alled, ignored and screened above the line
my %ruledirs; ## Things we can make by cloning (or sometimes moving)
my %knowndirs; ## Things we should recognize and ignore ## tagged with NOALL in the infile

while(<>){
	## Space and comments
	my $top = 1 .. /-------------------------/;
	my $active =  (! /#.*NOSCREEN/) && $top;
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	## They don't necessarily need auto-rules (so don't need colons)
	## screens after divider aren't screened, but are still listdirs
	my $number  = (s/^[0-9]+\.\s*//);
	my $name = $_;
	$name =~ s/[\s:].*//;
	$name =~ s|/$||;

	my $rule = (my ($d, $l) = /^([\w]*)(: .*)/);

	if ($active and $number){ say "screendirs += $name" }
	if ($rule or $number){
		if(/#.*NOALL/ || ! $active)
			{$knowndirs{$name}=0} else{$listdirs{$name}=0};
	}

	my $branch;
	while (($name, $branch) = $name =~ m|(.*)/([^/]*)|){
		say "$name/$branch: $name";
	}

	if ($rule){
		die "repeated rule for $d on line $." if defined $ruledirs{$d};
		$ruledirs{$d} = 0;

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
