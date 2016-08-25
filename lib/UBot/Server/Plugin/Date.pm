package UBot::Server::Plugin::Date;

use base 'Mojolicious::Controller';

use UBot::Util;
use UBot::Const;

my $CMD = 'date "+%Y-%m-%d %H:%M:%S"';

sub get_reply {
    my $self = shift;

    my $channel = $self->param('channel');

    my $reply_params = {
        channel => $channel,
    };

    $reply_params->{body} = UBot::Util::exec_cmd($CMD);
    $reply_params->{method} = UBot::Const::COMMAND_SAY;

    $self->render(json => $reply_params);
}

1;