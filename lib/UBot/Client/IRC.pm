package UBot::Client::IRC;

use strict;
use warnings FATAL => 'all';

use base qw/Bot::BasicBot/;

use UBot::Const;

sub set_ubot_reference {
    my $self = shift;
    my $ubot = shift;

    $self->{ubot} = $ubot;
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
