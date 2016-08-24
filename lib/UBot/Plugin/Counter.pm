package UBot::Plugin::Counter;

use strict;
use warnings FATAL => 'all';

use base qw/UBot::Plugin/;
use UBot::Const;
use UBot::Storage::Redis;

my $PATTERN = '^(\S*)(\+\+|\-\-)$';

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config
    };

    $self->{redis} = UBot::Storage::Redis->new($config);
    bless $self, $class;

    return $self;
}

sub get_pattern {
    return $PATTERN;
}

sub get_reply {
    my $self = shift;
    my $params = shift;

    my $reply_params = {
        channel => $params->{channel},
    };

    if ($params->{body} =~ /^(\S*)(\+\+|\-\-)$/) {
        my $key = $1;
        my $op = $2;
        my $value = $self->update_data($key, $op);

        $reply_params->{body} = "$key : $value";
        $reply_params->{method} = UBot::Const::CMD_SAY;
    }

    return $reply_params;
}

sub update_data {
    my $self = shift;
    my ($key, $op) = @_;

    my $value = $self->{redis}->get($key);
    $value ||= 0;

    if ($op eq '++') {
        $value++;
    } elsif ($op eq '--') {
        $value--;
    }

    $self->{redis}->set($key, $value);

    return $value;
}

1;