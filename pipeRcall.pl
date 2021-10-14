use strict;
use 5.10.0;

my $target = (grep(/.Rout$/, @ARGV))[0];
my $script = (grep(/.R$/, @ARGV))[0];
my $args = join " ", @ARGV;
my $call = 'rpcall("' . $args . '")';

open(OLD, "< $script");
open(NEW, "> $script.new");

while(<OLD>) {
	print NEW $_;
	last if /shellpipes/;
}

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
