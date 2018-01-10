use 5.10.0;
use strict;

my $rec = '<p><a href = "IMG">IMG:</a></p> <img src=THUMB></li><hr>';

my $name = shift(@ARGV);

say "<h1 style=\"color:red;\">$name</h1>";
while (<>){
	chomp;
	my $curr = $rec;
	next unless my ($image) = /^([^\s]*):$/;
	my $thumb = $image;
	$thumb =~ s/jpg$/png/;
	$thumb =~ s/gif$/png/;
	$thumb =~ s/pdf$/png/;
	$thumb =~ s/png$/thumb.png/;
	$curr =~ s/IMG/$image/g;
	$curr =~ s/THUMB/$thumb/;
	say $curr;
}
