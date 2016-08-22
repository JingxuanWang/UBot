package UBot;

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

our $LOG;

sub new {
    my ($class, $param) = @_;
    my $self = +{
        client => $param->{client},
        server => $param->{server},
        logger => $param->{logger}
    };

    # export to global namespace
    $LOG = $self->{logger};

    $LOG->debug("UBot started: ", Dumper $self);

    bless $self, $class;
    return $self;
}

sub start {
    my $self = shift;

    my $client_callback = sub {
        my $param = shift;

        $self->{logger}->debug("received_from_client: ", Dumper $param);

        $self->query_server($param);
    };

    # initialize callback
    $self->{client}->init($client_callback);

    # client start connecting
    $self->{client}->run();
}


sub query_server {
    my $self = shift;
    my $param = shift;

    my $reply_param = $self->{server}->get_reply($param);
    $self->{client}->process_server_reply($reply_param);
}

1;
