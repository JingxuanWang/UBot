package UBot::Server::Controller::Dispatcher;

use base 'Mojolicious::Controller';
use UBot::Const;

sub dispatch {
    my $self = shift;

    my $body = $self->param('body');

    my $dispatch_rules = $self->app->config->{dispatch_rules};

    for my $rule (%{$dispatch_rules}) {
        my $target_url = $dispatch_rules->{$rule};
        if ($body =~ /$rule/) {
            $self->redirect_to($target_url);
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