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
    my $body = "timestamp 2000-01-01 00:00:01";

    $t->get_ok("/query?body=timestamp")->status_is(302);
    $t->get_ok("/plugin/timestamp")->status_is(200)
        ->json_is('/method' => UBot::Const::COMMAND_SAY )
        ->json_like('/body' => qr/\d{1,10}/ );
    $t->get_ok("/plugin/timestamp?body=$body")->status_is(200)
        ->json_is('/method' => UBot::Const::COMMAND_SAY )
        ->json_like('/body' => qr/\d{1,10}/ );
}

test_get_reply();

done_testing();