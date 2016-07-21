package Parse::SAMGov::Entity;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;
use DateTime;
use DateTime::Format::Strptime;

#ABSTRACT: Object to denote each Entity in SAM

=head1 SYNOPSIS



=method DUNS

This holds the unique identifier of the entity, currently the Data
Universal Numbering System (DUNS) number. This has a maximum length of 9 characters.
This number can be gotten from Dun & Bradstreet.

=method DUNSplus4

This holds the DUNS+4 value which is of 4 characters. If an entity doesn't have
this value set, it will be set as '0000'.

=method CAGE

This holds the CAGE code of the Entity.

=cut

has 'DUNS';
has DUNSplus4 => default => sub { '0000' };
has 'CAGE';

=method DODAAC


=cut

has 'DODAAC';
has 'reg_purpose';

sub _parse_yyyymmdd {
    if (@_) {
        my $d = shift;
        state $Strp =
          DateTime::Format::Strptime->new(pattern   => '%Y%m%d',
                                          time_zone => 'America/New_York',);
        return $Strp->parse_datetime($d);
    }
    return;
}

has 'reg_date' => coerce => sub { _parse_yyyymmdd $_[0] };

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
