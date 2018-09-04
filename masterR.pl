use strict;
use 5.10.0;

while (<>){
	chomp;
	next unless /wrapper.p/;
	my ($files, $target) = /.*wrapper.pl\s*(.*?) > (.*).wrapR.r/;
	my @files = split /\s+/, $files;
	shift @files;
	# say "files:";
	# say join ",", @files;
	# say "target: $target";
	say 'source("' . "$target.run.r" . '")';
}
