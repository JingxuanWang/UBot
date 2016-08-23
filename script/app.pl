#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use lib "../lib";

use UBot;
use UBot::Log;
use UBot::Server;
use UBot::Client::IRC;
use UBot::Config;

use UBot::Plugin::Date;
use UBot::Plugin::Counter;
use UBot::Plugin::Wiki;

use Data::Dumper;

my $CONF_COMMON = "../conf/common.json";
my $CONF_IRC = "../conf/IRC.json";
my $CONF_SERVER = "../conf/server.json";

sub main {

    my $config_common = UBot::Config::get_conf($CONF_COMMON);
    my $config_irc = UBot::Config::get_conf($CONF_IRC);
    my $config_server = UBot::Config::get_conf($CONF_SERVER);

    my $client = UBot::Client::IRC->new(%{$config_irc});
    my $server = UBot::Server->new($config_server);
    my $logger = UBot::Log->new($config_common->{log});

    my $bot = UBot->new( +{
        client => $client,
        server => $server,
        logger => $logger
    });

    $bot->start();
}


main();