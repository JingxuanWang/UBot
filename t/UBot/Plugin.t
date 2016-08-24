#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use UBot::Server;
use UBot::Plugin::Date;
use UBot::Plugin::Counter;
use UBot::Plugin::Wiki;

sub test_abstact_methods {
    my $plugin = UBot::Plugin->new();
    eval {
        $plugin->get_pattern();
    };
    ok(defined $@);

    eval {
        $plugin->get_reply();
    };
    ok(defined $@);
}

test_abstact_methods();

done_testing();