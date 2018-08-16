use strict;
use 5.10.0;
use Digest::MD5 qw(md5_hex);
undef $/;

my ($fn) = @ARGV;
my $f = <>;

$f =~ s|https*://[a-zA-Z.]*/pubmed/([0-9]*)\S*|PMID:$1 |g;
$f =~ s|https*://dx.doi.org/|doi:|g;
$f =~ s/DOI:/doi:/g;

$f =~ s/\[?PMID:\s*([0-9]+)\]?/[RXREF:$1.pm]/g;

$f =~ s/\((doi:[^\s]*)\)/$1/g;
while ($f =~ /doi:([^\s]*)/){
	my $id = $1;
	my $md = md5_hex($id);
	$f =~ s/doi:[^\s]*/[RXREF:$md.doi][RXPOINT:$md=$id]/;
}

print $f;
