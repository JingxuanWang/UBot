package UBot::Plugin;

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

sub get_pattern {
    die "Please implement this function";
}

sub get_reply {
    die "Please implement this funciton";
}

1;