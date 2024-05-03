
## Code not used; idea is to have generic pgrtsv tags, but probably stupid
sub tagfield{
	my ($f) = @_;
	my @f = split /[\s|]+/, $f;
	@f = grep(/.../, @f);
	$#f=1 if $#f>1;
	my $t = join "",  @f;
	$t =~ tr/[A-Z]/[a-z]/;
	$t =~ s/\W//g;
	return $t;
}

