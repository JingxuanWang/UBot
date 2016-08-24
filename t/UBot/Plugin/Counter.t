#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use UBot::Const;
use UBot::Server;
use UBot::Plugin::Date;
use UBot::Plugin::Counter;
use UBot::Plugin::Wiki;


my @VALID_PATTERNS = qw/
        abc++
        def--
    /;

my @INVALID_PATTERNS = qw/
        ++abc
        --def
    /;

my $PARAMS = +{
    channel => "test_channel",
    body => "abc--",
    who => "test_user",
};

my $plugin = UBot::Plugin::Counter->new();

sub test_valid_patterns {
    my $plugin_pattern = $plugin->get_pattern();

    for my $valid_pattern (@VALID_PATTERNS) {
        ok($valid_pattern =~ /$plugin_pattern/);
    }
}

sub test_invalid_patterns {
    my $plugin_pattern = $plugin->get_pattern();

    for my $valid_pattern (@INVALID_PATTERNS) {
        ok(!($valid_pattern =~ /$plugin_pattern/));
    }
}

sub test_get_reply() {
    my $reply_params = $plugin->get_reply($PARAMS);

    ok($reply_params->{method} eq UBot::Const::CMD_SAY);
    ok($reply_params->{channel} eq $PARAMS->{channel});
    ok($reply_params->{body} =~ /(\S+) : \-*(\d+)/);

    $PARAMS->{body} = "abc++";

    $reply_params = $plugin->get_reply($PARAMS);

    ok($reply_params->{method} eq UBot::Const::CMD_SAY);
    ok($reply_params->{channel} eq $PARAMS->{channel});
    ok($reply_params->{body} =~ /(\S+) : \-*(\d+)/);
}

test_valid_patterns();
test_invalid_patterns();
test_get_reply();

done_testing();