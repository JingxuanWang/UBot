#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Test::Simple;
use Test::More;
use Test::MockModule;
use Test::MockObject;

use JSON;
use UBot::Storage::Redis;

my $VALID_CONFIG = +{
    server => "127.0.0.1:6379"
};

my $KEY_VALUE_MAP = +{
    test_key1 =>  "value1",
    test_key2 => +["value2"],
    test_key3 => +{"value3" => 1}
};

sub test_get_and_set {
    my $redis = UBot::Storage::Redis->new($VALID_CONFIG);

    for my $key (keys %{$KEY_VALUE_MAP}) {
        my $value = $KEY_VALUE_MAP->{$key};

        if (ref $value ne 'ARRAY' && ref $value ne 'HASH') {
            $redis->set( $key, $value );
            ok($redis->get($key) eq $value, "Redis get: $key : $value");
        } else {
            my $value_to_set = to_json($value);
            $redis->set($key, $value_to_set);
            my $value_got = $redis->get($key);
            ok($value_got eq to_json($value), "Redis get: $key : $value_got");
        }
    }
}

test_get_and_set();

done_testing();