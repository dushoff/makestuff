use strict;
use 5.10.0;

$_ = <>;
chomp;
my @head = split /\t/;
for my $head (@head){
	say "$head:";
}
say "";

my (%tags, @tags);
foreach(@head){
	s/\W.*//;
	die "repeated tag $_" if defined $tags{$_};
	$tags{$_}=1;
	push @tags, $_;
}

while(<>){
	my %rec;
	chomp;
	my @line = split /\t/, $_;
	die "Line too long" if @line > @head;
	for my $f (0..$#line){
		$recs{$tags[$f]} = $line[$f] if $line[$f];
	}
}

