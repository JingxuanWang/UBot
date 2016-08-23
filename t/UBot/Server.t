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

test_valid_plugin_init();
test_invalid_plugin_init();

done_testing();
