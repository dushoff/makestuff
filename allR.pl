use strict;
use 5.10.0;

while(<>){
	chomp;
	s/.*<\s*/source("/;
	s/\s*>.*/")/;
	next if /allchecks/; ## this is a dummy script
	say;
}

