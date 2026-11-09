#!/usr/bin/env perl
## Filter a make2graph dot file (see makegraph.md)
## Usage: perl mgFilter.pl <mode> [file.dot]
##   nom: drop makestuff machinery (makestuff/*, *.mk, Makefile, makestuff*.stamp)
##   ns:  drop slow and slowtarget directory nodes; merge slow/X into slowtarget/X
##   mf:  both, in one pass
## Nodes left with no edges by the filter are also dropped
use strict; use warnings;

my $mode = shift or die "Usage: mgFilter.pl nom|ns|mf [file]\n";
die "Unknown mode $mode\n" unless $mode =~ /^(nom|ns|mf)$/;
my $nom = $mode ne "ns";
my $ns = $mode ne "nom";

my (@lines, %label, %id);
while (<>) {
	push @lines, $_;
	if (/^(\w+)\s*\[label="([^"]*)"/) { $label{$1} = $2; $id{$2} = $1; }
}

my (%drop, %map);
for my $n (keys %label) {
	my $l = $label{$n};
	if ($nom) {
		$drop{$n} = 1 if $l =~ m{^makestuff(/|$)|\.mk$|^Makefile$|^makestuff.*\.stamp$};
	}
	if ($ns) {
		if ($l eq "slow" or $l eq "slowtarget") { $drop{$n} = 1; }
		elsif ($l =~ m{^slow/(.*)} and exists $id{"slowtarget/$1"}) {
			$map{$n} = $id{"slowtarget/$1"};
		}
	}
}

## Rewrite edges first, so we know which nodes end up isolated
my (%seen, %before, %after, @out);
for (@lines) {
	if (/^\s*(\w+)\s*->\s*(\w+)/) {
		my ($a, $b) = ($1, $2);
		$before{$a} = $before{$b} = 1;
		next if $drop{$a} or $drop{$b};
		$a = $map{$a} // $a; $b = $map{$b} // $b;
		next if $a eq $b or $seen{"$a $b"}++;
		$after{$a} = $after{$b} = 1;
		$_ = "$a -> $b ; \n";
	}
	push @out, $_;
}

for (@out) {
	if (/^(\w+)\s*\[label=/) {
		my $n = $1;
		next if $drop{$n} or $map{$n} or ($before{$n} and not $after{$n});
	}
	print;
}
