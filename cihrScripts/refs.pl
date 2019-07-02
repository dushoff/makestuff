use strict;
use 5.10.0;

my ($in, $ref) = @ARGV;
my %refs;

open F, $ref;
my $r=0;
while (<F>){
	next if /^$/;
	next if /^#/;
	chomp;
	my ($tag, $txt) = split / :: /, $_;
	die "$_ not parsed" unless $txt;
	$r++;
	$refs{$tag} = $r;
}

open I, $in;
undef $/;

my $md = <I>;

while (my($tag, $r) = each %refs){
	$md =~ s/$tag(\W)/$r$1/g;
}

$md =~ s/\(\(([^a-zA-Z()]*)\)\)/[$1]/g;

say $md;
