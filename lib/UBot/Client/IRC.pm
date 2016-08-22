package UBot::Client::IRC;

use strict;
use warnings FATAL => 'all';

use base qw/UBot::Client Bot::BasicBot/;

use Data::Dumper;

sub init {
    my $self = shift;
    my $received_from_client = shift;

    $self->{callback}->{received_from_client} = $received_from_client;

    return 1;
}

sub process_server_reply {
    my $self = shift;
    my $params = shift;

    $UBot::LOG->debug("Client_IRC process_server_reply", Dumper $params);

    if ($params->{method} eq "say") {
        $self->say($params);
    }
}

sub said {
    my $self = shift;
    my $params = shift;

    $UBot::LOG->debug("Client_IRC said", Dumper $params);

    my $who = $params->{who};
    return if ($who eq 'NickServ');

    $params->{method} = "said";
    $self->{callback}->{received_from_client}($params);
}


1;
