package UBot::Server;

use strict;
use warnings FATAL => 'all';

use JSON;

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config
    };

    bless $self, $class;

    return $self;
}

sub get_reply {
    my $self = shift;
    my $param = shift;

    my $body = $param->{body};

    my $reply_param = +{
        method => "say",
        channel => $param->{channel},
    };

    $reply_param->{body} = $self->content_analyze($param->{body});

    return $reply_param;
}

sub content_analyze {
    my $self = shift;
    my $body = shift;

    # timer
    if ($body eq "date") {
        return exec_cmd('date "+%Y-%m-%d %H:%M:%S"');
    }
    # counter
    elsif ($body =~ /^(\S*)\+\+$/) {
        my $var = $1;
        $self->{data}->{$var}++;
        return "$var : $self->{data}->{$var}";
    }
    # wiki search
    elsif ($body =~ /^wiki (.*)$/ ) {
        my $keyword = $1;
        my $search_url =
            "https://en.wikipedia.org/w/api.php?action=opensearch&search=$keyword&limit=1&namespace=0&format=json";
        my $ret = exec_cmd("curl '$search_url'");
        my $result = from_json($ret);
        for my $element (@$result) {
            if (ref $element eq "ARRAY" && $element->[0] =~ /^http/) {
                return $element->[0];
            }
        }

        return "wiki page for $keyword not found";
    }
}

sub exec_cmd {
    my $cmd = shift;
    $UBot::LOG->debug("Server exec command: ",$cmd);
    my $ret = `$cmd`;
    $UBot::LOG->debug("Server exec command result: ", $ret);
    return $ret;
}

1;