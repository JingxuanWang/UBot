package UBot::Client::Plugin::Date;

use UBot::Util;
use UBot::Const;

my $PATTERN = '^date$';
my $CMD = 'date "+%Y-%m-%d %H:%M:%S"';

sub get_pattern {
    return $PATTERN;
}

sub get_reply {
    my $self = shift;
    my $params = shift;

    $reply_params->{body} = UBot::Util::exec_cmd($CMD);
    $reply_params->{method} = UBot::Const::COMMAND_SAY;

    chomp($reply_params->{body});

    return $reply_params;
}

1;