package UBot::Const;

use strict;
use warnings FATAL => 'all';

use base 'Exporter';

# command to clients
use constant CMD_NO_OP => "no_op";
use constant CMD_SAY => "say";

# command to server
use constant CMD_SAID => "said";

our @EXPORT_OK = qw/
    CMD_NO_OP
    CMD_SAID
    CMD_SAY
    /;

1;