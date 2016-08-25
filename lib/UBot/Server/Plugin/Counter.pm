package UBot::Server::Plugin::Counter;

use base 'Mojolicious::Controller';

use UBot::Const;
use UBot::Server::Storage::Redis;

my $PATTERN = '^(\S+)(\+\+|\-\-)$';
my $REDIS_NAMESPACE = "UBot::Plugin::Counter::";

sub get_reply {
    my $self = shift;

    my $body = $self->param('body');
    my $channel = $self->param('channel');

    my $reply_params = {
        channel => $channel
    };

    if ($body =~ /$PATTERN/) {
        my $key = $1;
        my $op = $2;
        my $value = $self->update_data($key, $op);

        $reply_params->{content} = "$key : $value";
        $reply_params->{method} = UBot::Const::COMMAND_SAY;
    }

    $self->render(json => $reply_params);
}

sub update_data {
    my $self = shift;
    my ($key, $op) = @_;

    my $redis = $self->app->redis;

    # combine with Redis name space to avoid collision
    $key = $REDIS_NAMESPACE . $key;

    my $value = $redis->get($key);
    $value ||= 0;

    if ($op eq '++') {
        $value++;
    } elsif ($op eq '--') {
        $value--;
    }

    $redis->set($key, $value);

    return $value;
}

1;