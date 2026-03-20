use strict;
use 5.10.0;

@ARGV = grep {/MD$/} @ARGV;

while(<>){
	chomp;
	s/^@\w*\s*//;
	s/^$/\n---------------------------------------------------\n/;
	if (m|library/(.*).pdf|){
		my $lib = $&;
		s|library/(.*).pdf|[$1]($&)| if -e $lib;
	}
	s|[ *]*(.*pubmed.*)|; [Pubmed]($1)|; 
	s|[ *]*(.*/PMC.*)|; [PMC]($1)|; 
	s|[ *]*(.*/doi.*)|; [doi]($1)|; 
	if (s/^\t/\n/){
		for my $as (qw(
			BACKGROUND METHODS RESULTS CONCLUSIONS
			SETTING INTERVENTION OUTCOMES IMPLICATION
		)) {s/$as/\n\n$&/;}
	}
	say;
}
