#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Mojo;

use UBot::Const;
use UBot::Server::Plugin::Timestamp;

# turn on db log in this test
$ENV{MOJO_LOG_LEVEL} = "debug";

sub test_get_reply() {

    my $t = Test::Mojo->new('UBot::Server');
    my $body = "timestamp";

    $t->get_ok("/query?body=$body")->status_is(302);
    $t->get_ok('/plugin/date')
        ->status_is(200)
        ->json_has('method' => UBot::Const::COMMAND_SAY)
        ->json_has('body' => qr/\d{10}/);
}

test_get_reply();

done_testing();