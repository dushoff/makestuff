use strict;
use 5.10.0;

@ARGV = grep {/MD$/} @ARGV;

## Side effect: make notes/<tag>.md from the first ¶ of each entry, unless it exists
my $notesdir = "notes";
my ($tag, @note);

sub writenote {
	return unless defined $tag;
	my $fn = "$notesdir/$tag.md";
	mkdir $notesdir unless -d $notesdir;
	unless (-e $fn){
		open my $fh, ">", $fn or die "Can't write $fn";
		print $fh "$_\n" for @note;
		print $fh "\n----------------------------------------------------------------------\n\n";
		close $fh;
	}
	undef $tag;
}

while(<>){
	chomp;
	writenote() if /^\t/ or /^$/;
	if (/^@(\w+)/){
		$tag = $1;
		@note = ();
	} elsif (defined $tag){
		my $n = $_;
		$n =~ s|library/(.*).pdf|[$1](library/$1.pdf)|;
		$n =~ s|[ *]*(.*pubmed.*)|; [Pubmed]($1)|;
		$n =~ s|[ *]*(.*/PMC.*)|; [PMC]($1)|;
		$n =~ s|[ *]*(.*/doi.*)|; [doi]($1)|;
		push @note, $n;
	}
	s/^$/\n---------------------------------------------------\n/;
	s/^@(\w*)\s*// and say "[notes]($notesdir/$1.md)";
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
writenote();
