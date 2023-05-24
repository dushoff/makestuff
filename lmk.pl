use strict;
use 5.10.0;

## 2021 Oct 23 (Sat) We only need two kinds of directories
## active screendir and resting dir
## Assume they all have rules and let make sort it out
## ((no more moving))
## Let resting dir start with 0?
## What if there are things that I want, but don't want to all?
## Use NOALL for things that we never want to all.

my @screendirs;
my %alldirs; 
my %ignoredirs;
my %ruledirs;

while(<>){
	## Space and comments
	my $top = 1 .. /-------------------------/;
	## my $active =  (! /#.*NOSCREEN/) && $top; ## Delete this 2021 May 19 (Wed)
	next if /^$/;
	next if /^#/;
	chomp;
	die ("Non-blank line at $.") if /^\s*$/;

	## Numbered things are screens
	my $number  = (s/^[0-9]+\.\s*//);

	## Name is the first thing after the optional number
	my $name = $_;
	$name =~ s/[\s:].*//;
	$name =~ s|/$||;
	if ($number){
		push @screendirs, $name;
		$alldirs{$name}=0 unless (/#.*NOALL/ or m|Dropbox/|);
	}

	## Things that parse like rules are rules
	my $rule = (my ($d, $l) = /^([\w]*)(: .*)/);

	if ($rule or $number){
		$ignoredirs{$name} = 0;
	}

	my $branch;
	while (($name, $branch) = $name =~ m|(.*)/([^/]*)|){
		say "$name/$branch: $name";
	}

	if ($rule){
		die "repeated rule for $d on line $. of screen list"
			if defined $ruledirs{$d};
		$ruledirs{$d} = 0;

		## URL specifications
		if (my ($u) = /(https:[^\s]*)/){
			say "$d: url=$u";
		}

		## legacy specifications
		if (my ($u) = /(\.\.[^\s]*)/){
			say "$d: old=$u";
		}

		## Dropbox
		if (my ($u) = m|(\S*Dropbox/\S*)|){
			say "$d: dir=$u";
		}
	}
}

say "alldirs += " . (join " ", keys %alldirs);
say "Ignore += " . (join " ", keys %ignoredirs);
say "ruledirs = " . (join " ", keys %ruledirs);
say "screendirs += " . (join " ", @screendirs);
