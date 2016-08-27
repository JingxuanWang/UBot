package UBot::Server::Plugin::Wiki;

use base 'Mojolicious::Controller';

use Mojo::UserAgent;
use UBot::Const;
use JSON;

my $ACTION = "opensearch";
my $LIMIT = 1;
my $NAMESPACE = 0;
my $FORMAT = "json";

my $PATTERN = '^wiki (.*)$';
my $URL = "https://en.wikipedia.org/w/api.php?"
        ."action=$ACTION"
        ."&limit=$LIMIT"
        ."&namespace=$NAMESPACE"
        ."&format=$FORMAT"
        ."&search=";


sub get_reply {
    my $self = shift;

    my $body = $self->param('body');

    my $reply_params = +{ };

    if ($body =~ /$PATTERN/) {
        my $keyword = $1;
        chomp($keyword);

        my $ua = Mojo::UserAgent->new();
        my $result = $ua->get($URL.$keyword)->res->body;

        $reply_params->{body} = $self->parse_result($result);

        if ($reply_params->{body}) {
            $reply_params->{method} = UBot::Const::COMMAND_SAY;
        } else {
            $reply_params->{method} = UBot::Const::COMMAND_NO_OP;
        }
    } else {
        die "$body not hit $PATTERN";
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