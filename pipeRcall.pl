use strict;
use 5.10.0;

my $target = (grep(/.Rout$/, @ARGV))[0];
my $script = (grep(/.R$/, @ARGV))[0];
my $args = join " ", @ARGV;
my $call = 'rpcall("' . $args . '")';

open(OLD, "< $script");
open(NEW, "> $script.new");

my $shellpipes;

while(<OLD>) {
	print NEW $_;
	if (/shellpipes/){
		$shellpipes=0;
		last;
	}
}

die "No shellpipes call found" unless defined $shellpipes;

while(<OLD>) {
	last unless /rpcall/;
	print NEW $_ unless /$target/;
}

say NEW $call;
print NEW $_;

while(<OLD>) {
	print NEW $_;
	last if /shellpipes/;
}

rename($script, "$script.oldfile");
rename("$script.new", $script);
