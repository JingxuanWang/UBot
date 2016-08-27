package UBot::Client;

use strict;
use warnings FATAL => 'all';

use Mojo::UserAgent;
use UBot::Const;
use UBot::Log;
use UBot::Client::IRC;
use JSON;
use Data::Dumper;

my $MAX_REDIRECT = 10;

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

# call to start. will block the process and listen
sub start {
    my $self = shift;

    # give its own reference
    $self->{client}->set_ubot_reference($self);

    $self->{logger}->debug("Client start");

    # client start connect and listen
    # will block
    $self->{client}->run();
}

# main logic flow after received any message from client
sub received_from_client {
    my $self = shift;
    my $params = shift;

    $self->{logger}->debug("Client received_from_client: ", Dumper $params);

    # TODO: parameter transformation before query server

    my $tx = $self->post_to_server($self->{config}->{server_url}, $params);
    my $reply_params = +{};

    eval {
        $self->{logger}->debug("Server return: ", $tx->res->body);
        $reply_params = from_json($tx->res->body);
        $reply_params->{channel} = $params->{channel};
        $self->process_server_reply( $reply_params );
    };
    if ($@) {
        $self->{logger}->error( "Client ignore server reply: $@" );
    }
}

# query server with transformed parameters
sub post_to_server {
    my $self = shift;
    my $target_url = shift;
    my $params = shift;

    $self->{logger}->debug("Client post to server ", $target_url);

    my $ua = Mojo::UserAgent->new();
    return $ua->max_redirects($MAX_REDIRECT)->post(
        $target_url => form => $params
    );
}

# process reply from server
sub process_server_reply {
    my $self = shift;
    my $params = shift;

    $self->{logger}->debug("Client process_server_reply", Dumper $params);

    if (defined $params->{method}
        && $params->{method} eq UBot::Const::COMMAND_SAY) {
        $self->say($params);
    }
}

# unified action will translate actino parameter for different client
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