package UBot::Client;

use strict;
use warnings FATAL => 'all';

use Mojo::UserAgent;
use UBot::Const;
use UBot::Log;
use UBot::Client::IRC;
use JSON;
use Data::Dumper;

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config,
    };

    # initialize client according to config
    if (defined $config->{irc}) {
        $self->{client} = UBot::Client::IRC->new(%{$config->{irc}});
    }

    # initialize logger if there is one
    if (defined $config->{log}) {
        $self->{logger} = UBot::Log->new($config->{log});
    }

    print Dumper $self;

    # check if client exists
    if (!defined $self->{client} ) {
        die "Client undefined";
    }

    # check if logger exists
    if (!defined $self->{logger} ) {
        die "Logger undefined";
    }

    # chekc if server url exists
    if (!defined $self->{config}->{server_url}) {
        die "Undefined server url";
    }

    bless $self, $class;
    return $self;
}

sub start {
    my $self = shift;

    # give its own reference
    $self->{client}->init($self);

    # client start connecting
    $self->{client}->run();
}


sub received_from_client {
    my $self = shift;
    my $param = shift;
    $self->{logger}->debug("Client received_from_client: ", Dumper $param);
    $self->query_server($param);
}


sub query_server {
    my $self = shift;
    my $params = shift;

    $self->{logger}->debug("Client query_server", $self->{config}->{server_url});

    my $ua = Mojo::UserAgent->new();
    my $tx = $ua->max_redirects(10)->post(
        $self->{config}->{server_url} => form => $params
    );

    my $reply_params = from_json($tx->res->body);
    $reply_params->{channel} = $params->{channel};
    $self->process_server_reply($reply_params);
}

sub process_server_reply {
    my $self = shift;
    my $params = shift;

    $self->{logger}->debug("Client process_server_reply", Dumper $params);

    if (defined $params->{method}
        && $params->{method} eq UBot::Const::COMMAND_SAY) {
        $self->say($params);
    }
}

sub say {
    my $self = shift;
    my $params = shift;

    $self->{logger}->debug("Client say", Dumper $params);

    # is IRC client
    if (defined $self->{config}->{irc}) {
        $self->{client}->say($params);
    }
}

1;