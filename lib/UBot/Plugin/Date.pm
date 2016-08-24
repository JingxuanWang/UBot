package UBot::Plugin::Date;

use strict;
use warnings FATAL => 'all';

use UBot::Util;
use UBot::Const;

use base qw/UBot::Plugin/;


my $PATTERN = '^date$';
my $CMD = 'date "+%Y-%m-%d %H:%M:%S"';


sub get_pattern {
    return $PATTERN;
}

sub get_reply {
    my $self = shift;
    my $params = shift;

    my $reply_params = {
        channel => $params->{channel},
    };

    $reply_params->{body} = UBot::Util::exec_cmd($CMD);
    $reply_params->{method} = UBot::Const::CMD_SAY;

    return $reply_params;
}

1;