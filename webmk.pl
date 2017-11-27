use 5.10.0;
use strict;

my $recipe = 'wget -O $@ "URL"';
my @images;
my @thumbs;

while (<>){
	chomp;
	next if /^\s*$/;
	next if /^#/;

	my ($fn, $url) = split /\s+/;
	$fn = "files/$fn";

	my $ext="";
	$ext = $url if $url;
	$ext =~ s/.*\.//;
	$ext =~ tr/[A-Z]/[a-z]/;

	$fn = "$fn.$ext" if $ext;
	(my $name, $ext) = $fn =~ /(.*)\.(.*)/;
	push @images, $fn;
	push @thumbs, "$name.thumb.png";

	my $rline = $recipe;

	say "$fn:";

	if ($url){
		$url =~ s|^|http://| unless $url =~/^http/;
		$rline =~ s/URL/$url/;
		say "\t$rline";
	}
}

say "images = " . join " ", @images;
say "thumbs = " . join " ", @thumbs;
