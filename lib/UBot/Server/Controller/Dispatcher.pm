package UBot::Server::Controller::Dispatcher;

use base 'Mojolicious::Controller';
use UBot::Const;
use Data::Dumper;

sub dispatch {
    my $self = shift;

    my $body = $self->param('body');

    my $dispatch_rules = $self->app->config->{dispatch_rules};

    for my $rule (%{$dispatch_rules}) {
        my $route_name = $dispatch_rules->{$rule};
        my $target_url = $self->url_for($route_name);
        if ($body =~ /$rule/) {
            $self->app->log->debug("dispatcher: redirect to $route_name");
            $self->redirect_to( $target_url->query(body => $body) );
            return;
        }
    }

    $self->render(
        json => {
            method  => UBot::Const::COMMAND_NO_OP,
            channel => UBot::Const::CHANNEL_DEFAULT,
            body    => UBot::Const::CONTENT_NO_PLUGIN
        }
    );
}

1;