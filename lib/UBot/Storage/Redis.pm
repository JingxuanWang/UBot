package UBot::Storage::Redis;

use strict;
use warnings FATAL => 'all';

use Redis;

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config
    };

    # initialize redis according to the config
    $self->{redis} = Redis->new(%{$config});
    bless $self, $class;
    return $self;
}

sub get {
    my $self = shift;
    my $key = shift;

    return $self->{redis}->get($key);
}

sub set {
    my $self = shift;
    my ($key, $value) = @_;

    $self->{redis}->set($key, $value);
}

1;