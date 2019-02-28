use strict;
use 5.10.0;

undef $/;

$_ = <>;

s|</p>\s*<p>|$&</p><p>|gs;
s|<p><strong>([^<]*)</strong></p>|<p><strong><u>$1</u></strong></p>|gs;
s|<p><em>([^<]*)</em></p>|<p><em><u>$1</u></em></p>|gs;

print;
