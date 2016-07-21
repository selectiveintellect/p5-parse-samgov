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

=method DODAAC

This holds the DODAAC code of the entity.

=cut

has 'DUNS';
has DUNSplus4 => default => sub { '0000' };
has 'CAGE';
has 'DODAAC';

=method extract_code

This denotes whether the SAM entry is active, expired, deleted/deactivated
during extraction of the data.

=method regn_purpose

This denotes whether the purpose of registration is Federal Assistance Awards,
All Awards, IGT-only, Federal Assistance Awards & IGT or All Awards & IGT.

=cut

has 'extract_code';
has 'regn_purpose';

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

=method regn_date

Registration date of the entity with the input in YYYYMMDD format and it returns
a DateTime object.

=method expiry_date

Expiration date of the registration of the entity. The input is in YYYYMMDD
format and it returns a DateTime object.

=method lastupdate_date

Last update date of the registration of the entity. The input is in YYYYMMDD
format and it returns a DateTime object.

=method activation_date

Activation date of the registration of the entity. The input is in YYYYMMDD
format and it returns a DateTime object.

=cut

has 'regn_date' => coerce => sub { _parse_yyyymmdd $_[0] };
has 'expiry_date' => coerce => sub { _parse_yyyymmdd $_[0] };
has 'lastupdate_date' => coerce => sub { _parse_yyyymmdd $_[0] };
has 'activation_date' => coerce => sub { _parse_yyyymmdd $_[0] };

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
