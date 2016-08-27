package UBot::Const;

use strict;
use warnings FATAL => 'all';

use base 'Exporter';

# command to clients
use constant COMMAND_NO_OP => "no_op";
use constant COMMAND_SAY => "say";

# command to server
use constant COMMAND_SAID => "said";

# default channel
use constant CHANNEL_DEFAULT => "default";

# default content
use constant CONTENT_NO_PLUGIN => "No plugin matched";

our @EXPORT_OK = qw/
    COMMAND_NO_OP
    COMMAND_SAID
    COMMAND_SAY

    CHANNEL_DEFAULT

    CONTENT_NO_PLUGIN
    /;

1;