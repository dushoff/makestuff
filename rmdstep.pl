## Developing from rstep.pl
## Eventually figure out whether to unify
use strict;
use 5.10.0;

my @read = qw(read. read_ load source);
my @write = qw(write. write_ pdf ggsave save save.image);
my $funpattern = '.*?';
my $filepattern = '[\\w._-]*';
my $listpattern = '[\\w._ -]*';

my $target = $ARGV[0];
$target =~ s/\.rmd$// or die;

### Read and parse
undef $/;
my $f = <>;

### Hotwords
## Double comment to cancel
$f =~ s/^##.*//;
$f =~ s/\n##.*//g;
$f =~ s/noStep.*//s;
while ($f =~ s/\bstepSource\s*($listpattern)//){
	say "## stepSource";
	say "$target.pdf $target.html: $1\n";
}
while ($f =~ s/\bstepProduct\s*($listpattern)//){
	say "## stepProduct";
	say "$1: $target.pdf $target.html ;\n";
}

## Peel out comments
$f =~ s/^#.*//;
$f =~ s/\n#.*//g;

foreach my $r (@read){
	my %rf;
	while ($f =~ s/\b$r\w*\s*\(\s*"($filepattern)"//){
		$rf{$1}=0;
	}
	if (%rf){
		say "## $r";
		say "## Hi, Steve!";
		say "$target.pdf $target.html: "
			, join " ", keys %rf;
		say "";
	}
}

foreach my $w (@write){
	my %wf;
	while ($f =~ s/\b$w\w*\s*\($funpattern"($filepattern)"//){
		$wf{$1}=0;
	}
	if (%wf){
		say "## $w";
		say join (" ", keys %wf)
			. ": $target.pdf $target.html ; ";
		
		say "";
	}
}

