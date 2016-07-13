use strict;
use 5.10.0;

while(<>){
	s/^SCALEFIG[\s0-9.]*/FIG /;
	s/^COLFIG/WIDEFIG/;
	print;
}
