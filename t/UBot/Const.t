#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use UBot::Const;

sub test_const {
    ok(UBot::Const::CMD_NO_OP eq "no_op");
    ok(UBot::Const::CMD_SAY eq "say");
    ok(UBot::Const::CMD_SAID eq "said");
}

test_const();

done_testing();