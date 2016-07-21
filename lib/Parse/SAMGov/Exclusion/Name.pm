package Parse::SAMGov::Exclusion::Name;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;

#ABSTRACT: Defines the Name object that is used in the Exclusion

=head1 SYNOPSIS

    # use either for an individual or entity
    my $name = Parse::SAMGov::Exclusion::Name->new(
                    prefix => 'Mr',
                    first => 'John',
                    middle => 'James',
                    last => 'Johnson',
                    suffix => 'Jr',
                );
    say "this is an individual" unless $name->entity;

    my $entity = Parse::SAMGov::Exclusion::Name->new(entity => 'ABC Corp Inc.');
    say "this is an entity " if $name->entity;

=method new

Creates a new Name object for an individual or an entity but not both. If the
entity field is empty, it assumes the object represents an individual otherwise
the object represents an entity with the name in the entity field.

=method entity

Sets/gets the entity name. If the object represents an individual, this will be
undefined. If the object represents an entity this will be the name of the
entity.

=method prefix

Holds the prefix such as Mr,Ms,Mrs,Sir etc. for the name of the individual
being excluded.

=method first

Holds the first name of the individual being excluded.

=method middle

Holds the middle name of the individual being excluded.

=method last

Holds the last name of the individual being excluded.

=method suffix

Holds the suffix of the actual name of the person being excluded such as Jr, II,
III etc.

=cut

has 'entity';
has 'prefix';
has 'first';
has 'middle';
has 'last';
has 'suffix';

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
