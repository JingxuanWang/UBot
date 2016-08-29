#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Mojo;

use UBot::Const;
use UBot::Server::Plugin::Wiki;

# turn on db log in this test
$ENV{MOJO_LOG_LEVEL} = "debug";

sub test_get_reply() {

    my $t = Test::Mojo->new('UBot::Server');
    my $body = "wiki olympic";

    $t->get_ok("/query?body=$body")->status_is(302);
    $t->get_ok("/plugin/wiki?body=$body")
        ->status_is(200)
        ->json_is('/method' => UBot::Const::COMMAND_SAY)
        ->json_like('/body' => qr/^http/);
}

test_get_reply();

done_testing();