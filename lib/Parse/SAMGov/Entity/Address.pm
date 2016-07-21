package Parse::SAMGov::Entity::Address;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;

#ABSTRACT: Defines the Address object of the entity.

=head1 SYNOPSIS

    my $addr = Parse::SAMGov::Entity::Address->new(
        address => '123 Baker Street, Suite 1A',
        city => 'Boringville',
        state => 'ZB',
        country => 'USA',
        zip => '21900-1234',
    );

=method new

Creates a new Address object for the entity or individual.

=method address

This fields holds the address information without the city/state/country and
postal/zip code.

=method city

The city name of the entity's address.

=method state

The state or province of the entity's address.

=method district

The congressional district of the entity's address.

=method country

The three character country code for the entity's address.

=method zip

The zip or postal code of the entity's address.

=cut

has 'address';
has 'city';
has 'state';
has 'district';
has 'country';
has 'zip';

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
