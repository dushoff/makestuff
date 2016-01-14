use 5.10.0;
use strict;

my $h = <>;
chomp $h;
my @h = split /\t/, $h;

my %tot;

while (<>){
	chomp;
	my %ln;
	my @ln = split /\t/, $_;
	for (my $i=0; $i<=$#ln; $i++){
		$ln{$h[$i]} = $ln[$i];
	}

	my $amt=$ln{Amount};
	my @charge = split /,\s*/, $ln{Who};
	my @paid = split /,\s*/, $ln{Paid};

	$amt =~ s/^[\$]//;
	{no warnings 'uninitialized';
		foreach (@paid){
			$tot{$_} += $amt/(1+$#paid);
		}
		foreach (@charge){
			$tot{$_} -= $amt/(1+$#charge);
		}
	}
}

if (defined $tot{All}){
	my $All = $tot{All};
	delete $tot{All};
	my @people = keys %tot;
	foreach (@people){
		$tot{$_} += $All/(1+$#people);
	}
}

foreach (sort keys %tot){
	say "$_ : $tot{$_}";
}
