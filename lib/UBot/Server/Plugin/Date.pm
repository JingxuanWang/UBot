package UBot::Server::Plugin::Date;

use base 'Mojolicious::Controller';

use UBot::Const;

my $PATTERN = '^date (\d+)$';

sub get_reply {
    my $self = shift;

    my $body = $self->param('body');

    my $timestamp;

    # match timestamp if possible
    if ($body =~ /$PATTERN/) {
        $timestamp = $1;
    }

    # if no timestamp matched, use current timestamp
    $timestamp ||= time;

    my $reply_params = +{ };

    $reply_params->{body} = get_date_from_timestamp($timestamp);
    $reply_params->{method} = UBot::Const::COMMAND_SAY;

    chomp($reply_params->{body});

    $self->render(json => $reply_params);
}

sub get_date_from_timestamp {
    my $timestamp = shift;
    my ($second, $minute, $hour, $day, $month, $year, $weekday, $yesterday, $is_dst)
        = localtime($timestamp);
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d",
        $year + 1900, $month + 1, $day, $hour, $minute, $second
    );
}


1;