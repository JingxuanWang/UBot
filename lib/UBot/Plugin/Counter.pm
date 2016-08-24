package UBot::Plugin::Counter;

use strict;
use warnings FATAL => 'all';

use base qw/UBot::Plugin/;
use UBot::Const;

my $PATTERN = '^(\S*)(\+\+|\-\-)$';

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
        my $var = $1;
        my $op = $2;
        if ($op eq '++') {
            $self->{data}->{$var}++;
        } elsif ($op eq '--') {
            $self->{data}->{$var}--;
        }

        $reply_params->{body} = "$var : $self->{data}->{$var}";
        $reply_params->{method} = UBot::Const::CMD_SAY;
    }

    return $reply_params;
}

1;