#!/usr/bin/perl -w

use strict;

my $target = shift(@ARGV);
$target =~ s/\.[^.]*$//;
my $f = "";

while (<>){
	# Lines starting with # are comments
	next if /^#/;

	# Lines without colons always start paragraphs
	# If a generic rule has a colon, it must be proceeded by an explicit paragraph break!!
	s/^[^:]*$/\n$&/;

	$f .= $_;
}

# print "$f\n\n\n\n\n";

# Split into paragraphs
foreach my $par (split /\n\n+/, $f){
	next unless $par;

	# Parse paragraph headline
	my @ln = split /\n/, $par;
	my $head = shift @ln;
	my ($comm, @default) = split /\s+/, $head;
	my $default = join " ", @default;

	# Look for specific rule
	my $rule;
	foreach (@ln){
		# $rule = $1 if /^\s*$target\s+(.*)/;
		$rule = $1 if /\b$target\b.*?:\s*([^\s].*)/;
	}
	my $ln;

	if (defined $rule){
		$ln = "$comm $rule\n";
	} elsif ($default){
		$ln = "$comm $default\n";
	} 

	if ($ln){
		print $ln unless $ln =~ /\bNULL\s*$/;
	} else {
		die "No rule for $comm";
	}
}
