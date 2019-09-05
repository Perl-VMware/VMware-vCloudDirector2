package VMware::vCloudDirector2;

# ABSTRACT: Interface to VMWare vCloud Directory REST API

use strict;
use warnings;

# VERSION
# AUTHORITY

use Moose;
use Method::Signatures;
use MooseX::Types::Path::Tiny qw/Path/;
use VMware::vCloudDirector2::API;
use VMware::vCloudDirector2::Error;
use VMware::vCloudDirector2::Object;

# ------------------------------------------------------------------------

=head1 DESCRIPTION

Thinish wrapper of the VMware vCloud Director REST API.

This differs from L<VMware::vCloudDirector> in that it uses the JSON flavoured
version of the API, which has subtly different naming conventions (which is why
I didn't try to make the code handle both flavours), but is much easier to work
with when doing write operations.

THIS IS AT AN EARLY STAGE OF DEVELOPMENT - PROTOTYPING REALLY - AND MAY CHANGE
DRAMATICALLY OR EAT YOUR DATA.

The target application is to read information from a vCloud instance, so the
ability to change or write data to the vCloud system has not been implemented
as yet...

=head1 SYNOPSIS

    # THIS IS AT AN EARLY STAGE OF DEVELOPMENT - PROTOTYPING REALLY
    # IT MAY CHANGE DRAMATICALLY OR EAT YOUR DATA.

    use VMware::vCloudDirector2

    my $vcd = VMware::vCloudDirector2->new(
        hostname   => $host,
        username   => $user,
        password   => $pass,
        orgname    => $org,
        ssl_verify => 0,
    );
    my @org_list = $vcd->org_list;


=head2 Attributes

=head3 hostname

Hostname of the vCloud server.  Must have a vCloud instance listening for https
on port 443.

=head3 username

Username to use to login to vCloud server.

=head3 password

Password to use to login to vCloud server.

=head3 orgname

Org name to use to login to vCloud server - this defaults to C<System>.

=head3 timeout

Command timeout in seconds.  Defaults to 120.

=head3 default_accept_header

The default MIME types to accept.  This is automatically set based on the
information received back from the API versions.

=head3 ssl_verify

Whether to do standard SSL certificate verification.  Defaults to set.

=head3 ssl_ca_file

The SSL CA set to trust packaged in a file.  This defaults to those set in the
L<Mozilla::CA>

=head2 debug

Set debug level.  The higher the debug level, the more chatter is exposed.

Defaults to 0 (no output) unless the environment variable C<VCLOUD_API_DEBUG>
is set to something that is non-zero.  Picked up at create time in C<BUILD()>

=cut

has debug => ( is => 'rw', isa => 'Bool', default => 0 );    # Defaults to no debug info

has hostname   => ( is => 'ro', isa => 'Str',  required  => 1 );
has username   => ( is => 'ro', isa => 'Str',  required  => 1 );
has password   => ( is => 'ro', isa => 'Str',  required  => 1 );
has orgname    => ( is => 'ro', isa => 'Str',  required  => 1, default => 'System' );
has ssl_verify => ( is => 'ro', isa => 'Bool', predicate => '_has_ssl_verify' );
has timeout    => ( is => 'rw', isa => 'Int',  predicate => '_has_timeout' );
has ssl_ca_file => ( is => 'ro', isa => Path, coerce => 1, predicate => '_has_ssl_ca_file' );
has _ua => ( is => 'ro', isa => 'LWP::UserAgent', predicate => '_has_ua' );
has _debug_trace_directory =>
    ( is => 'ro', isa => Path, coerce => 1, predicate => '_has_debug_trace_directory' );

has api => (
    is      => 'ro',
    isa     => 'VMware::vCloudDirector2::API',
    lazy    => 1,
    builder => '_build_api',
    handles => [qw( GET PUT POST DELETE )],
);

method _build_api () {
    my @args = (
        hostname => $self->hostname,
        username => $self->username,
        password => $self->password,
        orgname  => $self->orgname,
        debug    => $self->debug
    );
    push( @args, timeout     => $self->timeout )     if ( $self->_has_timeout );
    push( @args, ssl_verify  => $self->ssl_verify )  if ( $self->_has_ssl_verify );
    push( @args, ssl_ca_file => $self->ssl_ca_file ) if ( $self->_has_ssl_ca_file );
    push( @args, _debug_trace_directory => $self->_debug_trace_directory )
        if ( $self->_has_debug_trace_directory );
    push( @args, _ua => $self->_ua ) if ( $self->_has_ua );

    return VMware::vCloudDirector2::API->new(@args);
}

# ------------------------------------------------------------------------
has org_listref => (
    is      => 'ro',
    isa     => 'ArrayRef[VMware::vCloudDirector2::Object]',
    lazy    => 1,
    builder => '_build_org_listref',
    traits  => ['Array'],
    handles => {
        org_list => 'elements',
        org_map  => 'map',
        org_grep => 'grep',
    },
);
method _build_org_listref { return [ $self->api->GET('/api/org/') ]; }

# ------------------------------------------------------------------------
method query (@args) {
    my $uri = $self->api->query_uri->clone;
    $uri->query_form(@args);
    return $self->api->GET($uri);
}

# ------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

1;
