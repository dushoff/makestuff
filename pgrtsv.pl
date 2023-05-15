use strict;
use 5.10.0;

$/ = "";

$_ = <>;
chomp;
s/:\s*$//;
my @head = split /:\s*\n/;
say join "\t", @head;

my (%names);
for my $f (0..$#head){
	$_ = $head[$f];
	s/\W.*//;
	die "repeated name $_" if defined $names{$_};
	$names{$_}=$f;
}

while(<>){
	my @fields;
	my @lines = split /\n/, $_;
	warn "Too many lines" if @lines > @head;
	foreach my $ln (@lines){
		my ($t, $f) = $ln =~ /(\w*):\s*(.*)/;
		die "Unrecognized name $t" unless defined $names{$t};
		$fields[$names{$t}] = $f if $f;
	}
	## say $#fields;
	do {no warnings 'uninitialized'; 
		say join "\t", @fields if $#fields >= 0;
	};
}

