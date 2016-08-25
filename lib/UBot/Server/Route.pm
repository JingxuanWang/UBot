package UBot::Server::Route;

use strict;
use warnings;

sub setup {
    my $app = shift;

    my $r = $app->routes;

    my $route_configs = $app->config->{routes};
    $r->namespaces($app->config->{controller_namespaces});

    for my $rc (@$route_configs) {
        if (exists $rc->{params}) {
            my %param_map = map {
                my ($key, $value) = each %$_;
                $key => qr/$value/
            } @{$rc->{params}};
            $r->route($rc->{url}, %param_map)
                ->via($rc->{method})
                ->to($rc->{dest})
                ->name($rc->{name});
        } else {
            $r->route($rc->{url})
                ->via($rc->{method})
                ->to($rc->{dest})
                ->name($rc->{name});
        }
    }
}

1;
