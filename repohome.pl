use strict;
use 5.10.0;

while(<>){
	next if /^#/;
	next if /^$/;
	chomp;

	my $default = "git_dushoff_";
	my $url = $_;
	my $und = "_";

	s|https://|| or die "unrecognized line $_";
	my ($host, $org, $name) = split /\//;

	next if $host =~ /overleaf/;
	$host = "git" if $host =~ /github/;
	$host = "bit" if $host =~ /bitbucket/;

	$name =~ s/\.git$// or die "unrecognized name $name";

	my $dirname = $host . $und . $org . $und . $name;
	$dirname =~ s/$default//;
	say  "rhdir/$dirname: url=$url";
	say  "rhdir/$dirname: ; " . '$(rhmake)';
}
