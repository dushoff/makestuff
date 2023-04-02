use strict;
use 5.10.0;

$/ = "";

$_ = <>;
chomp;
my @head = split /\t/;
say;

my (%tags);
for my $f (0..$#head){
	$_ = $head[$f];
	s/\W.*//;
	die "repeated tag $_" if defined $tags{$_};
	$tags{$_}=$f;
}

while(<>){
	my @fields;
	my @newline;
	my @recs = split /\n/, $_;
	die "Too many records" if @recs > @head;
	foreach my $rec (@recs){
		my ($t, $f) = $rec =~ /(\w*):\s*(.*)/;
		die "Unrecognized tag $t" unless defined $tags{$t};
		$fields[$tags{$t}] = $f
	}
	do {no warnings 'uninitialized'; 
		say join "\t", @fields;
	};
}

