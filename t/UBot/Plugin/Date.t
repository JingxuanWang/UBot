#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

my @VALID_PATTERNS = qw/
        date
    /;

my @INVALID_PATTERNS = qw/
        date1
    /;

my $PARAMS = +{
    channel => "test_channel",
    body => "date",
    who => "test_user",
};

my $plugin = UBot::Plugin::Date->new();

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

    ok($reply_params->{method} eq "say");
    ok($reply_params->{channel} eq $PARAMS->{channel});
    ok($reply_params->{body} =~ /\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/);
}

test_valid_patterns();
test_invalid_patterns();
test_get_reply();

done_testing();