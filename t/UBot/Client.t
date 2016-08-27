#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;
use Test::Mojo;

use UBot::Config;
use UBot::Client;
use UBot::Client::IRC;

my $CONFIG_FILE = "../conf/development/client-irc.conf";

my $t = Test::Mojo->new('UBot::Server');

my $config = UBot::Config::get_conf($CONFIG_FILE);
my $client = UBot::Client->new($config);


sub test_client_creation {
    my $irc = +{};
    my $server_url = "http://localhost:3000/query";
    my $log = +{
        "path" => "../log/ubot-client-irc.log"
    };


    my $config_no_irc = +{
        server_url => $server_url,
        log => $log
    };

    eval {
        UBot::Client->new($config_no_irc);
    };
    ok($@, "config without irc defined should not pass");

    my $config_no_logger = +{
        irc => $irc,
        server_url => $server_url,
    };

    eval {
        UBot::Client->new($config_no_logger);
    };
    ok($@, "config without logger defined should not pass");

    my $config_no_server_url = +{
        irc => $irc,
        log => $log
    };

    eval {
        UBot::Client->new($config_no_server_url);
    };
    ok($@, "config without server_url defined should not pass");

    my $valid_config = +{
        irc => $irc,
        server_url => $server_url,
        log => $log
    };

    eval {
        UBot::Client->new($valid_config);
    };
    ok(!$@, "valid config should pass");
}

test_client_creation();

done_testing();