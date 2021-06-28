use strict;
use 5.10.0;

## If I have a number, I'm a screendir
## If I have a rule, I'm a ruledir
## If I have a rule _or_ a number, I'm a dir (to be split as listdir or resting)
## listdir and resting should be changed to activedir and restingdir
## both the perl names AND the .mk variables (which is why I don't just do it)

## screendirs are printed out immediately, based on numbers
my %listdirs; ## These are ignored and added to alldirs
my %resting; ## These are just ignored 
my %ruledirs; ## Things we can make by cloning and moving

while(<>){
	## Space and comments
	my $top = 1 .. /-------------------------/;
	## my $active =  (! /#.*NOSCREEN/) && $top; ## Delete this 2021 May 19 (Wed)
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	## They don't necessarily need auto-rules (so don't need colons)
	my $number  = (s/^[0-9]+\.\s*//);
	my $name = $_;
	$name =~ s/[\s:].*//;
	$name =~ s|/$||;

	my $rule = (my ($d, $l) = /^([\w]*)(: .*)/);

	if ($top and $number){ say "screendirs += $name" }
	if ($rule or $number){
		if(/#.*NOALL/ || ! $top) {$resting{$name}=0} 
			else{$listdirs{$name}=0};
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
say "resting = " . (join " ", keys %resting);
