package Ubot::Client;

use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config
    };

    bless $self, $class;

    return $self;
}


1;