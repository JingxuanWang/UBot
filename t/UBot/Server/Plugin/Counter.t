#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Mojo;

use UBot::Const;
use UBot::Server::Plugin::Date;

# turn on db log in this test
$ENV{MOJO_LOG_LEVEL} = "debug";

sub test_get_reply() {
    my $t = Test::Mojo->new('UBot::Server');
    my $body = "abc++";

    $t->post_ok("/query" => form => {
            body => $body
        })->status_is(302);

    $t->post_ok('/plugin/counter' => form => {
            body => $body
        })
        ->status_is(200)
        ->json_is('/method' => UBot::Const::COMMAND_SAY)
        ->json_like('/body' => qr/(\S+) : \-*(\d+)/);

    $body = "abc--";

    $t->post_ok('/plugin/counter' => form => {
            body => $body
        })
        ->status_is(200)
        ->json_is('/method' => UBot::Const::COMMAND_SAY)
        ->json_like('/body' => qr/(\S+) : \-*(\d+)/);

}

test_get_reply();

done_testing();