package UBot::Config;

use strict;
use warnings FATAL => 'all';
use JSON;


sub get_conf {
    my $config_file = shift;
    open FILE, '<', $config_file
        or die "Can not open file $config_file";

    my $json_text  = join '', <FILE>;
    return from_json( $json_text );
}

1;