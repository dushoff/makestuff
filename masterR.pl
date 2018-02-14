use strict;
use 5.10.0;

while (<>){
	chomp;
	next unless /vanilla/;
	s/[^<]*<\s*/source("/;
	s/\s*>.*/")/;
	s/wrapR/run/;
	say;
}
