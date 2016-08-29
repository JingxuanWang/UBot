package UBot::Server::Plugin::Timestamp;

use base 'Mojolicious::Controller';

use UBot::Const;
use POSIX qw(mktime);

my $PATTERN = 'timestamp (\d\d\d\d)\-(\d\d)\-(\d\d) (\d\d):(\d\d):(\d\d)';

sub get_reply {
    my $self = shift;
    my $body = $self->param('body');

    my $reply_params = +{ };

    # if match date pattern, convert date to timestamp
    if ($body =~ /$PATTERN/) {
        my $year = $1;
        my $month = $2;
        my $day = $3;
        my $hour = $4;
        my $minute = $5;
        my $second = $6;

        $reply_params->{body} =
            mktime($second, $minute, $hour, $day, $month - 1, $year - 1900);
    } else {
        # otherwise use current timestamp instead
        $reply_params->{body} = time;
    }

    $reply_params->{method} = UBot::Const::COMMAND_SAY;

    chomp($reply_params->{body});

    $self->render(json => $reply_params);
}

sub to_stamp {
    my ($year, $month, $day, $hour, $minute, $second) = @_;
    return mktime($second, $minute, $hour, $day, $month - 1, $year - 1900);
}

1;