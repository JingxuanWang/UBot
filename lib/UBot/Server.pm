package UBot::Server;

use strict;
use warnings FATAL => 'all';

use Mojo::Base 'Mojolicious';
use JSON;
use UBot::Server::Route;
use UBot::Log;
use UBot::Server::Storage::Redis;

# This method will run once at server start
sub startup {
    my $app = shift;

    # loading confiruations
    load_config($app);
    UBot::Server::Route::setup($app);

    register_redis($app);

    $app->secrets($app->config->{secret});
    $app->sessions->default_expiration(3600 * 24 * 7);
}

sub register_redis {
    my $app = shift;

    my $redis = UBot::Server::Storage::Redis->new( $app->config->{redis} );

    # attach log instance to $app->redis
    $app->attr("_redis", sub { return $redis; });
    $app->helper(
        'redis' => sub {
            my $self = shift;
            return $self->app->_redis;
        }
    );

}

# load configurations
sub load_config {
    my $app = shift;

    # create shortcut for stage
    my $STAGE = $app->{mode};

    # load app config
    my $conf_file = "conf/$STAGE/server.conf";
    $app->plugin( 'JSONConfig', { 'file' => $conf_file } );
}

1;