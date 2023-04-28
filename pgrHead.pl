use strict;
use 5.10.0;

undef $/;

my $f = <>;
my @recs = split /\n{2,}/, $f;

my @tags;
my %tags;
for (@recs){
	my @fields;
	my @lines = split /\n/, $_;
	foreach my $ln (@lines){
		my ($t, $f) = $ln =~ /(\w*):\s*(.*)/;
		unless (defined $tags{$t}){
			push @tags, $t;
			$tags{$t}=0;
		}
	}
}

unshift @recs, (join ": \n", @tags) . ":";
say join "\n\n", @recs;

