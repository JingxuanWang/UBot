package UBot::Util;

use strict;
use warnings FATAL => 'all';


sub exec_cmd {
    my $cmd = shift;
    $UBot::LOG->debug("Server exec command: ",$cmd);
    my $ret = `$cmd`;
    $UBot::LOG->debug("Server exec command result: ", $ret);
    return $ret;
}

1;