use strict;
use 5.10.0;

@ARGV = grep {/MD$/} @ARGV;

while(<>){
	chomp;
	s/^$/\n---------------------------------------------------\n/;
	s/^@\w*\s*//;
	if (m|library/(.*).pdf|){
		my $lib = $1;
		my $art = "library/$lib.pdf";
		my $supp = "library/${lib}Supp.pdf";
		s|library/(.*).pdf|[$lib]($art)| if -e $&;
		s/$/; [Supp]($supp)/ if -e $supp;
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
