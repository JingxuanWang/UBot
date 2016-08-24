package UBot::Plugin::Wiki;

use strict;
use warnings FATAL => 'all';

use UBot::Util;
use UBot::Const;
use JSON;

use base qw/UBot::Plugin/;

my $PATTERN = '^wiki (.*)$';
my $URL = "https://en.wikipedia.org/w/api.php?action=opensearch&limit=1&namespace=0&format=json&search=";

sub get_pattern {
    return $PATTERN;
}

sub get_reply {
    my $self = shift;
    my $params = shift;

    my $reply_params = {
        channel => $params->{channel},
    };

    if ($params->{body} =~ /$PATTERN/) {
        my $keyword = $1;
        my $result = UBot::Util::exec_cmd("curl '$URL$keyword'");
        $reply_params->{body} = $self->parse_result($result);

        if ($reply_params->{body}) {
            $reply_params->{method} = UBot::Const::CMD_SAY;
        } else {
            $reply_params->{method} = UBot::Const::CMD_NO_OP;
        }
    }


    return $reply_params;
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