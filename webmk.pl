use 5.10.0;
use strict;

## Wikimedia (and some other hosts) now reject wget's default User-Agent
## with 429 "Please set a proper user-agent" -- so identify ourselves.
my $recipe = 'wget --user-agent="dushoff-makestuff-webpix/1.0 (+https://github.com/dushoff/makestuff)" -O $@.tmpfig "URL" && mv $@.tmpfig $@';
my @images;
my @thumbs;

while (<>){
	chomp;
	next if /^\s*$/;
	next if /^#/;

	my ($fn, $url) = split /\s+/;
	$fn = "webpix/$fn";

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
