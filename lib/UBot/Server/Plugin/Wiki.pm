package UBot::Server::Plugin::Wiki;

use base 'Mojolicious::Controller';

use UBot::Util;
use UBot::Const;
use JSON;

my $PATTERN = '^wiki (.*)$';
my $URL = "https://en.wikipedia.org/w/api.php?action=opensearch&limit=1&namespace=0&format=json&search=";


sub get_reply {
    my $self = shift;

    my $body = $self->param('body');
    my $channel = $self->param('channel');

    my $reply_params = {
        channel => $channel,
    };

    if ($body =~ /$PATTERN/) {
        my $keyword = $1;
        my $result = UBot::Util::exec_cmd("curl '$URL$keyword'");
        #print STDERR $result;
        $reply_params->{body} = $self->parse_result($result);

        if ($reply_params->{body}) {
            $reply_params->{method} = UBot::Const::COMMAND_SAY;
        } else {
            $reply_params->{method} = UBot::Const::COMMAND_NO_OP;
        }
    }

    $self->render(json => $reply_params);
}

sub parse_result {
    my $self = shift;
    my $result = shift;

    my $result_in_perl = from_json($result);

    for my $element (@$result_in_perl) {
        if (ref $element eq "ARRAY"
            && defined $element->[0]
            && $element->[0] =~ /^http/) {
            return $element->[0];
        }
    }
}

1;