package UBot::Log;

use strict;
use warnings FATAL => 'all';

use Encode qw/encode/;
use Fcntl ':flock';
use Data::Dumper;

sub new {
    my ($class, $param) = @_;
    my $self = +{
        path => $param->{path},
    };
    bless $self, $class;
    return $self;
}

sub debug {
    my $self = shift;
    my @contents = @_;
    $self->_out('debug', @contents);
}

sub info {
    my $self = shift;
    my @contents = @_;
    $self->_out('info', @contents);
}

sub warn {
    my $self = shift;
    my @contents = @_;
    $self->_out('warn', @contents);
}

sub error {
    my $self = shift;
    my @contents = @_;
    $self->_out('error', @contents);
}

sub fatal {
    my $self = shift;
    my @contents = @_;
    $self->_out('fatal', @contents);
}

sub _out {
    my $self = shift;
    my $level = shift;
    my @contents = @_;

    my $log = join("\t", @contents);

    # remove line break for contents
    # there should always be one line per output
    #$log =~ s/\n//g;

    $self->_append($self->{path}, $self->_format($level, $log));
}

sub _append {
    my $self = shift;
    my ($path, $log) = @_;

    $path .= "." . _get_local_date();
    my $encoded_log = encode('UTF-8', $log, Encode::FB_CROAK);
    open HANDLE, ">>", $path or die "Can not open file $path";

    flock HANDLE, LOCK_EX;
    HANDLE->print($encoded_log) or die "Can't write to log: $!";
    flock HANDLE, LOCK_UN;

    close HANDLE;

    print $encoded_log;
}

sub _format {
    my $self = shift;
    return'[' . localtime . '] [' . shift . '] ' . shift . "\n";
}

sub _get_local_date {
    my ($second, $minute, $hour, $day, $month, $year, $weekday, $yesterday, $is_dst) = localtime;
    return sprintf("%04d%02d%02d", $year + 1900, $month + 1, $day);
}

1;