#!/usr/bin/env perl

use strict;
use warnings;

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use UBot::Server;
use UBot::Plugin::Date;
use UBot::Plugin::Counter;
use UBot::Plugin::Wiki;


my $VALID_CONFIG = {
    plugins => {
        "date"      => "UBot::Plugin::Date",
        "counter"   => "UBot::Plugin::Counter",
        "wiki"      => "UBot::Plugin::Wiki"
    }
};

my $INVALID_CONFIG = +{
     plugins => {
        "date"      => "UBot::Plugin::Date1",
        "counter"   => "UBot::Plugin::Counter2",
        "wiki"      => "UBot::Plugin::Wiki3"
     }
};

sub test_valid_plugin_init {
    my $server = UBot::Server->new($VALID_CONFIG);

    for my $plugin_name (keys %{$VALID_CONFIG->{plugins}}) {
        my $class_name = $VALID_CONFIG->{plugins}->{$plugin_name};
        ok($server->{plugins}->{$plugin_name}->isa($class_name));
    }
}

sub test_invalid_plugin_init {
    eval {
        my $server = UBot::Server->new($INVALID_CONFIG);
    };
    ok(defined $@);
}

sub test_get_reply {
    my $params = +{
        method => "said",
        channel => "test_channel",
        body => "abc",
        who => "test user"
    };

    my $server = UBot::Server->new($VALID_CONFIG);
    my $reply_param = $server->get_reply($params);

    ok($reply_param->{method} eq "no_op");

    $params->{body} = "date";
    $reply_param = $server->get_reply($params);

    ok($reply_param->{method} eq "say");
}

test_valid_plugin_init();
test_invalid_plugin_init();
test_get_reply();

done_testing();
