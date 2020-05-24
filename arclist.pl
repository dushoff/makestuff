use 5.10.0;

my $proj = 0;
while(<>){
	$proj += 100 if /-------------------------------/;
	if (/^XX\./){
		$proj++;
		s/^XX/$proj/;
	}
	print;
}
