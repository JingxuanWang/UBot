package UBot::Server::Plugin::StackOverflow;

use base 'Mojolicious::Controller';

use Mojo::UserAgent;
use UBot::Util;
use UBot::Const;
use JSON;

my $PAGE = 1;
my $PAGE_SIZE = 1;
my $ORDER = "desc";
my $SORT = "relevance";
my $SITE = "stackoverflow";

my $PATTERN = '^stackoverflow (.*)$';
my $URL = "https://api.stackexchange.com/2.2/search?"
        ."page=$PAGE"
        ."&pagesize=$PAGE_SIZE"
        ."&order=$ORDER"
        ."&sort=$SORT"
        ."&site=$SITE"
        ."&intitle=";


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

    if (defined $result_in_perl->{items}->[0]) {
        return $result_in_perl->{items}->[0]->{link};
    }
}

1;