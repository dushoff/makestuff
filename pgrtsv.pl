use strict;
use 5.10.0;

$/ = "";

$_ = <>;
chomp;
s/:\s*$//;
my @head = split /:\s*\n/;
say join "\t", @head;

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
	warn "Too many records" if @recs > @head;
	foreach my $rec (@recs){
		my ($t, $f) = $rec =~ /(\w*):\s*(.*)/;
		die "Unrecognized tag $t" unless defined $tags{$t};
		$fields[$tags{$t}] = $f if $f;
	}
	## say $#fields;
	do {no warnings 'uninitialized'; 
		say join "\t", @fields if $#fields >= 0;
	};
}

