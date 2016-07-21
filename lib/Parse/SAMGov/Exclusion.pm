package Parse::SAMGov::Exclusion;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;
use DateTime;
use DateTime::Format::Strptime;
use Parse::SAMGov::Exclusion::Name;
use Parse::SAMGov::Exclusion::Address;

#ABSTRACT: defines the SAM Exclusions object

=head1 SYNOPSIS

    my $exclusion = Parse::SAMGov::Exclusion->new;
    $exclusion->classification("firm");
    $exclusion->DUNS('123456789');
    $exclusion->CAGE('7ABZ1');

    ...

=method new

This method creates a new Exclusion object.

=method classification

Identifies the exclusion Classification Type as either a Firm, Individual,
Special Entity Designation, or Vessel. The maximum length of this field is 50
characters.

=cut

has classification => ();

=method name

This sets/gets an object of L<Parse::SAMGov::Exclusion::Name> which can hold
either the entity name being excluded or the individual name being excluded.

=cut

has name => default => sub {
    return Parse::SAMGov::Exclusion::Name->new;
};

=method address

This sets/gets an object of L<Parse::SAMGov::Exclusion::Address> which holds the
primary address of the entity or individual being excluded. It includes the
city, two character abbreviation of state/province, three character abbreviation
of country and a 10 character zip/postal code.

=cut

has address => default => sub {
    return Parse::SAMGov::Exclusion::Address->new;
};

=method DUNS

This holds the unique identifier of the excluded entity, currently the Data
Universal Numbering System (DUNS) number. Exclusion records with a
classification type of Firm must have a DUNS number. It may be found in
exclusion records of other classification types if the individual, special
entity or vessel has a DUNS number. This has a maximum length of 9 characters.

=cut

has 'DUNS';

=method xprogram

Exclusion Program identifies if the exclusion is Reciprocal, Nonreciprocal or Procurement.
For any exclusion record created on or after August 25, 1995, the value will
always be Reciprocal.

=cut

has 'xprogram';

=method agency

Exclusion Agency identifies the agency which created the exclusion.

=cut

has 'xagency';

=method CT_code

This identifies the legacy Excluded Parties List System (EPLS) Cause & Treatment
(CT) Code associated with the exclusion. CT Codes were replayed by the Exclusion
Type in SAM. Exclusions created after August 2012 will not have CT Codes. They
will only have Exclusion Types.

=cut

has 'CT_code';

=method xtype

This identifies the Exclusion Type for the record replacing the CT Code.
Exclusion Type is a simplified, easier to understand way to identify why the
entity is being excluded.

=cut

has 'xtype';

=method comments

This field provides the agency creating the exclusion space to enter additional
information as necessary. The maximum length allowed is 4000 characters.

=cut

has 'comments';

sub _parse_date {
    if (@_) {
        my $d = shift;
        $d = '12/31/2200' if $d =~ /indefinite/i;
        state $Strp =
          DateTime::Format::Strptime->new(pattern   => '%m/%d/%Y',
                                          time_zone => 'America/New_York',);
        return $Strp->parse_datetime($d);
    }
    return;
}

=method active_date

This field identifies the date the exclusion went active. It returns a DateTime
object. It accepts an input of the format MM/DD/YYYY, and converts it to a
DateTime object with the timezone used as America/New_York.

=cut

has active_date => (coerce => sub { _parse_date $_[0] });

=method termination_date

This field identifies the date the exclusion will be terminated. The date
'12/31/2200' is denoted as indefinite exclusion for now. This field also returns
a DateTime object.

=cut

has termination_date => (coerce => sub { _parse_date $_[0] });

=method record_status

This identifies the record as begin Active or Inactive. This can be blank if the
record is active.

=cut

has 'record_status';

=method crossref

Identifies other names/aliases with which the entity being excluded has been
identified. For example, companies who do business under other names may have
those other names listed here.

=cut

has 'crossref';

=method SAM_number

The internal number used by SAM to identify exclusion records. Since only Firm
exclusion records are required to have a DUNS number, SAM needed a way to
uniquely track exclusion records of other classification types.

=cut

has 'SAM_number';

=method CAGE

The CAGE code associated with the excluded entity. Mostly found on Firm
exclusion records, but could be in other types if the Individual, Special
Entity, or Vessel has a CAGE code.

=cut

has 'CAGE';

=method NPI

The National Provider Identifier (NPI) associated with the exclusion. Healthcare
providers acquire their unique 10-digit NPIs from the Centers for Medicare &
Medicaid Services (CMS) at the Department of Health & Human Services (HHS) to
identify themselves in a standard way throughout their industry.

=cut

has 'NPI';

1;
__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>