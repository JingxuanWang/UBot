package UBot::Client::IRC;

use strict;
use warnings FATAL => 'all';

use base qw/Bot::BasicBot/;

use UBot::Const;
use Mojo::UserAgent;
use JSON;


sub init {
    my $self = shift;
    my $ubot = shift;

    $self->{ubot} = $ubot;
    return 1;
}

# hook method
sub said {
    my $self = shift;
    my $params = shift;

    my $who = $params->{who};
    return if ($who eq 'NickServ');

    $params->{method} = UBot::Const::COMMAND_SAID;
    $self->{ubot}->received_from_client( $params );
}




1;
