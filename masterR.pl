use strict;
use 5.10.0;

while (<>){
	chomp;
	next unless /wrapper.p/;
	my ($files, $target) = /.*wrapper.pl\s*(.*?) > (.*).wrapR.r/;
	my @files = split /\s+/, $files;
	shift @files;
	my @inputs = grep(!/\.R$/, @files);
	my @scripts = grep(/\.R$/, @files);

	# Dev stuff
	## This is WET code; the internal stuff has already parsed out these files, and now we're doing it again ☹
	say "\n## Making file $target";
	say "## Input files: " . join ", ", @inputs;

	foreach my $script (@scripts){
		say "## SCRIPT: $script";
		print `perl -npe "last unless /^#/" $script`;
	}

	say 'source("' . "$target.run.r" . '")';
}
