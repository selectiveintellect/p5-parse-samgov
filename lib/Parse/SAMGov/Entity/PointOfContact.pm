package Parse::SAMGov::Entity::PointOfContact;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;
extends 'Parse::SAMGov::Entity::Address';
use Email::Valid;

#ABSTRACT: Defines the Point of Contact object of the entity.

=head1 SYNOPSIS

    my $addr = Parse::SAMGov::Entity::PointOfContact->new(
        first => 'John',
        middle => 'F',
        last => 'Jameson',
        title => 'CEO',
        address => '123 Baker Street, Suite 1A',
        city => 'Boringville',
        state => 'ZB',
        country => 'USA',
        zip => '21900-1234',
        phone => '18888888888',
        phone_ext => '101',
        fax => '18887777777',
        phone_nonUS => '442222222222',
        email => 'abc@pqr.com',
    );

=method new

Creates a new Point of Contact object for the entity or individual. This
inherits all the methods of the L<Parse::SAMGov::Entity::Address> object.

=method first

Get/Set the first name of the point of contact.

=method middle

Get/Set the middle initial of the point of contact.

=method last

Get/Set the last name of the point of contact.

=method title

Get/Set the title of the point of contact. Example is CEO, President, etc.

=method phone

Get/Set the U.S. Phone number of the point of contact.

=method phone_ext

Get/Set the U.S. Phone number extension of the point of contact if any.

=method phone_nonUS

Get/Set the non-U.S. phone number of the point of contact.

=method fax

Get/Set the fax number of the point of contact.

=method email

Get/Set the email of the point of contact.

=cut

use overload
  fallback => 1,
  '""'     => sub {
    my $str = '';
    if (length $_[0]->first and length $_[0]->last) {
        $str .= $_[0]->first;
        $str .= ' ' . $_[0]->middle if length $_[0]->middle;
        $str .= ' ' . $_[0]->last;
        $str .= ', ' . $_[0]->title if length $_[0]->title;
        $str .= ', ' . $_[0]->address if length $_[0]->address;
        $str .= ', ' . $_[0]->city if length $_[0]->city;
        $str .= ', ' . $_[0]->state if length $_[0]->state;
        $str .= ', ' . $_[0]->country if length $_[0]->country;
        $str .= ' - ' . $_[0]->zip if length $_[0]->zip;
        $str .= '. Email: ' . $_[0]->email if $_[0]->email;
        $str .= '. Phone: ' . $_[0]->phone if $_[0]->phone;
        $str .= ' x' . $_[0]->phone_ext if $_[0]->phone_ext;
        $str .= '. Fax: ' . $_[0]->fax if $_[0]->fax;
        $str .= '. Phone(non-US): ' . $_[0]->phone_nonUS if $_[0]->phone_nonUS;
        $str .= '.';
    }
    return $str;
  };

has 'first';
has 'middle';
has 'last';
has 'title';
has 'phone';
has 'phone_ext';
has 'phone_nonUS';
has 'fax';
has 'email' => coerce => sub { Email::Valid->address($_[0]); };

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
