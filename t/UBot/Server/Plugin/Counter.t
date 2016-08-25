#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::More;
use Test::Mojo;

use UBot::Const;
use UBot::Server::Plugin::Date;

# turn on db log in this test
$ENV{MOJO_LOG_LEVEL} = "debug";

my $PARAMS = +{
    channel => "test_channel",
    body => "abc--",
    who => "test_user",
};


sub test_get_reply() {
    my $t = Test::Mojo->new('UBot::Server');
    my $channel = "abcdefg";
    my $body = "abc++";

    $t->post_ok("/query" => form => {
            channel => $channel,
            body => $body
        })->status_is(302);
    $t->post_ok('/plugin/counter' => form => {
            channel => $channel,
            body => $body
        })
        ->status_is(200)
        ->json_has('method' => UBot::Const::COMMAND_SAY)
        ->json_has('channel' => $channel)
        ->json_has('body' => qr/(\S+) : \-*(\d+)/);
}

test_get_reply();

done_testing();