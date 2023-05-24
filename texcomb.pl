use 5.10.1;
use strict;

while(<>){
	chomp;

	## Choose brackets
	s/\(([^\s)]*)\)\bC\b\(([^\s)]*)\)/{ $1 \\choose $2 }/g;

	## Weird fraction notation
	s|/([^/]*)//([^/]*)/|\\frac{ $1 }{ $2 }|g;

	## pmatrix format
	s/\[\[$/\\begin{pmatrix}/;
	s/^\]\]/\\end{pmatrix}/;
	while (s/^\[(.*)\t(.*)\]/[$1 & $2]/){}
	s/^\[(.*)\]/$1\\cr/;
	say;
}
