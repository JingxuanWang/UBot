#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use UBot::Const;

sub test_const {
    ok(UBot::Const::COMMAND_NO_OP eq "no_op");
    ok(UBot::Const::COMMAND_SAY eq "say");
    ok(UBot::Const::COMMAND_SAID eq "said");
}

test_const();

done_testing();