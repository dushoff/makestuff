use strict;
use 5.10.0;

$_ = <>;
chomp;
my @head = split /\t/;
say;
say "";

my (%tags, @tags);
foreach(@head){
	s/\W.*//;
	die "repeated tag $_" if defined $tags{$_};
	$tags{$_}=1;
	push @tags, $_;
}

while(<>){
	chomp;
	my @line = split /\t/, $_;
	die "Line too long" if @line > @head;
	for my $f (0..$#line){
		say "$tags[$f]: $line[$f]" if $line[$f]
	}
	say "";
}

