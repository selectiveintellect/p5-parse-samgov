package Parse::SAMGov::Exclusion::Address;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;

#ABSTRACT: Defines the Address object of the entity being excluded.

=head1 SYNOPSIS

    my $addr = Parse::SAMGov::Exclusion::Address->new(
        address => ['123 Baker Street', 'Suite 1A'],
        city => 'Boringville',
        state => 'ZB',
        country => 'USA',
        zip => '21900-1234',
    );

=method new

Creates a new Address object for the entity or individual being excluded.

=method address

This fields holds an array reference of the street information, and any other
portion of the address of the entity or individual being excluded.

=method city

The city name of the excluded entity's address.

=method state

The state or province two-character abbreviation of the excluded entity's
address.

=method country

The three character country code for the excluded entity's address.

=method zip

The zip or postal code of the excluded entity's address.

=cut

has 'address' => [];
has 'city';
has 'state';
has 'country';
has 'zip';

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
