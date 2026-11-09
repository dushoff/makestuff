#!/usr/bin/env perl
## Simplify a make2graph dot file for slowtarget.mk projects:
## drop the slow and slowtarget directory nodes, and merge each slow/X
## into slowtarget/X when that node exists (so the graph shows only slowtarget/X)
use strict; use warnings;

my (@lines, %label, %id);
while (<>) {
	push @lines, $_;
	if (/^(\w+)\s*\[label="([^"]*)"/) { $label{$1} = $2; $id{$2} = $1; }
}

my (%drop, %map);
for my $n (keys %label) {
	my $l = $label{$n};
	if ($l eq "slow" or $l eq "slowtarget") { $drop{$n} = 1; }
	elsif ($l =~ m|^slow/(.*)| and exists $id{"slowtarget/$1"}) {
		$map{$n} = $id{"slowtarget/$1"};
	}
}

my %seen;
for (@lines) {
	if (/^(\w+)\s*\[label=/) {
		next if $drop{$1} or $map{$1};
	} elsif (/^\s*(\w+)\s*->\s*(\w+)/) {
		my ($a, $b) = ($1, $2);
		next if $drop{$a} or $drop{$b};
		$a = $map{$a} // $a; $b = $map{$b} // $b;
		next if $a eq $b or $seen{"$a $b"}++;
		$_ = "$a -> $b ; \n";
	}
	print;
}
