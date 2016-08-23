package UBot::Server;

use strict;
use warnings FATAL => 'all';

use JSON;

sub new {
    my ($class, $config) = @_;

    my $self = +{
        config => $config,
        plugins => +{}
    };

    if (defined $self->{config}->{plugins}) {
        no strict 'refs';
        for my $plugin_name (keys %{ $self->{config}->{plugins} }) {
            my $class = $self->{config}->{plugins}->{$plugin_name};
            $self->{plugins}->{$plugin_name} = $class->new();
        }
        use strict 'refs';
    }

    bless $self, $class;

    return $self;
}

sub get_reply {
    my $self = shift;
    my $params = shift;

    for my $plugin (values %{$self->{plugins}}) {
        my $pattern = $plugin->get_pattern();
        if ($params->{body} =~ /$pattern/) {
            return $plugin->get_reply($params);
        }
    }

    my $reply_param = +{
        method => "say",
        channel => $params->{channel},
    };

    return $reply_param;
}

1;