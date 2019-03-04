use strict;
use 5.10.0;

my ($in, $ref) = @ARGV;
my %refs;

open F, $ref;
while (<F>){
	next if /^$/;
	next if /^#/;
	chomp;
	my ($tag, $txt) = split / :: /, $_;
	die "$_ not parsed" unless $txt;
	$refs{$tag} = $txt;
}

open I, $in;
undef $/;

my $md = <I>;

while (my($tag, $r) = each %refs){
	$md =~ s/$tag(\W)/$r$1/g;
}

## K, this is a mess. QC doesn't work if tags aren't tags (for old refs)
## $md =~ s/\(\(([^a-zA-Z()]*)\)\)/[$1]/g;
## Check by hand for now
$md =~ s/\(\(([^()]*)\)\)/[$1]/g;

say $md;
