#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use lib "../lib";

use UBot;
use UBot::Log;
use UBot::Server;
use UBot::Client::IRC;
use UBot::Config;

use Data::Dumper;

my $CONF_COMMON = "../conf/common.json";
my $CONF_IRC = "../conf/IRC.json";


sub main {

    my $config_common = UBot::Config::get_conf($CONF_COMMON);
    my $config_irc = UBot::Config::get_conf($CONF_IRC);

    my $bot = UBot->new( +{
        client => UBot::Client::IRC->new( %{$config_irc} ),
        server => UBot::Server->new(),
        logger => UBot::Log->new($config_common->{log})
    });

    $bot->start();
}


main();