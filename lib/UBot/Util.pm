package UBot::Util;

use strict;
use warnings FATAL => 'all';

sub exec_cmd {
    my $cmd = shift;
    my $ret = `$cmd`;
    return $ret;
}

1;