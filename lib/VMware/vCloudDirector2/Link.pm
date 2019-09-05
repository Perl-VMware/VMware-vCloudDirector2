package VMware::vCloudDirector2::Link;

# ABSTRACT: Link within the vCloud

use strict;
use warnings;

# VERSION
# AUTHORITY

use Moose;
use Method::Signatures;
use MooseX::Types::URI qw(Uri);
use Ref::Util qw(is_plain_hashref);
use VMware::vCloudDirector2::Error;

# ------------------------------------------------------------------------

has object => (
    is            => 'ro',
    isa           => 'VMware::vCloudDirector2::Object',
    required      => 1,
    weak_ref      => 1,
    documentation => 'Parent object of link'
);

has mime_type => ( is => 'ro', isa => 'Str', predicate => 'has_mime_type' );
has href => ( is => 'ro', isa => Uri, required => 1, coerce => 1 );
has rel  => ( is => 'ro', isa => 'Str', required  => 1 );
has name => ( is => 'ro', isa => 'Str', predicate => 'has_name' );
has type => ( is => 'ro', isa => 'Str' );

# ------------------------------------------------------------------------
around BUILDARGS => sub {
    my ( $orig, $class, $first, @rest ) = @_;

    my $params = is_plain_hashref($first) ? $first : { $first, @rest };

    if ( $params->{hash} ) {
        my $hash = delete $params->{hash};
        $params->{href} = $hash->{-href} if ( exists( $hash->{-href} ) );
        $params->{rel}  = $hash->{-rel}  if ( exists( $hash->{-rel} ) );
        $params->{name} = $hash->{-name} if ( exists( $hash->{-name} ) );
        if ( exists( $hash->{-type} ) ) {
            my $type = $hash->{-type};
            $params->{mime_type} = $type;
            $params->{type} = $1 if ( $type =~ m|^application/vnd\..*\.(\w+)\+xml$| );
        }
    }

    return $class->$orig($params);
};

# ------------------------------------------------------------------------

=head3 DELETE

Make a delete request to the URL in this link.  Returns Objects.  Failure will
generate an exception.  See L<VMware::vCloudDirector2::API/DELETE>.

=cut

method DELETE () { return $self->object->api->GET( $self->href ); }

=head3 GET

Make a get request to the URL in this link.  Returns Objects.  Failure will
generate an exception.  See L<VMware::vCloudDirector2::API/GET>.

=cut

method GET () { return $self->object->api->GET( $self->href ); }

=head3 POST

Make a post request with the specified payload to the URL in this link. Returns
Objects.  Failure will generate an exception.  See
L<VMware::vCloudDirector2::API/POST>.

=cut

method POST ($xml_hash) { return $self->object->api->GET( $self->href, $xml_hash ); }

=head3 PUT

Make a put request with the specified payload to the URL in this link.  Returns
Objects.  Failure will generate an exception.  See
L<VMware::vCloudDirector2::API/PUT>.

=cut

method PUT ($xml_hash) { return $self->object->api->GET( $self->href, $xml_hash ); }

# ------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

1;
