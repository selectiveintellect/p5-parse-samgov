package Parse::SAMGov::Entity;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;
use URI;
use DateTime;
use DateTime::Format::Strptime;
use Parse::SAMGov::Entity::Address;
use Parse::SAMGov::Entity::PointOfContact;

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

=method name

The legal business name of the entity.

=method dba_name

The Doing Business As (DBA) name of the entity.

=method company_division

The company division listed in the entity.

=method division_no

The divison number of the company division.

=method physical_address

This is the physical address of the entity represented as a
Parse::SAMGov::Entity::Address object.

=cut

has 'name';
has 'dba_name';
has 'company_division';
has 'division_no';
has 'physical_address' => default => sub { return Parse::SAMGov::Entity::Address->new; };

=method start_date

This denotes the business start date. It takes as input the date in YYYYMMDD
format and returns a DateTime object.

=method fiscalyear_date

This denotes the current fiscal year end close date in YYYYMMDD format and
returns a DateTime object.

=method url

The corporate URL is denoted in this method. Returns a URI object and takes a
string value.

=method entity_structure

Get/Set the entity structure of the entity.

=cut

has 'start_date' => coerce => sub { _parse_yyyymmdd $_[0] };
has 'fiscalyear_date' => coerce => sub { _parse_yyyymmdd $_[0] };
has 'url' => coerce => sub { URI->new($_[0]) };
has 'entity_structure';

=method incorporation_state

Get/Set the two-character abbreviation of the state of incorporation.

=method incorporation_country

Get/Set the three-character abbreviation of the country of incorporation.

=cut

has 'incorporation_state';
has 'incorporation_country';


=method biztype

Get/Set the various business types that the entity holds. Requires an array
reference. The full list of business type codes can be retrieved from the SAM
Functional Data Dictionary.

=method biztype_sba

Get/Set the Small Business Administration business type codes as an array ref.

=method NAICS

Get/Set the NAICS codes for the entity. This requires an array reference. The
first element in the array is the primary NAICS code of the entity.

=method NAICS_exceptions

This holds an array of NAICS codes that are exceptions. Requires an array ref.

=method PSC

Get/Set the PSC codes for the entity. This requires an array reference.

=method creditcard

This denotes whether the entity uses a credit card.

=method correspondence_flag

This denotes whether the entity prefers correspondence by mail, fax or email.

=method mailing_address

The mailing address of the entity as a L<Parse::SAMGov::Entity::Address> object.

=method POC_gov

This denotes the Government business Point of Contact for the entity and holds an
L<Parse::SAMGov::Entity::PointOfContact> object.

=method POC_gov_alt

This denotes the alternative Government business  Point of Contact for the entity and
holds an L<Parse::SAMGov::Entity::PointOfContact> object.

=method POC_pastperf

This denotes the Past Performance Point of Contact for the entity and
holds an L<Parse::SAMGov::Entity::PointOfContact> object.

=method POC_pastperf_alt

This denotes the alternative Past Performance Point of Contact for the entity and
holds an L<Parse::SAMGov::Entity::PointOfContact> object.

=method POC_elec

This denotes the electronic business Point of Contact for the entity and
holds an L<Parse::SAMGov::Entity::PointOfContact> object.

=method POC_elec_alt

This denotes the alternative electronic business Point of Contact for the entity and
holds an L<Parse::SAMGov::Entity::PointOfContact> object.

=method delinquent_fed_debt

Get/Set the delinquent federal debt flag.

=method exclusion_status

Get/Set the exclusion status flag.

=method is_private

This flag denotes whether the listing is private or not.

=method disaster_response

This holds an array ref of disaster response (FEMA) codes that the entity falls
under, if applicable.

=cut

has 'biztype' => default => sub { [] };
has 'biztype_sba' => default => sub { [] };
has 'NAICS' => default => sub { [] };
has 'NAICS_exceptions' => default => sub { [] };
has 'PSC' => default => sub { [] };
has 'creditcard';
has 'correspondence_flag';
has 'mailing_address' => default => sub { return Parse::SAMGov::Entity::Address->new; };
has 'POC_gov' => default => sub { return
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'POC_gov_alt' => default => sub {
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'POC_pastperf' => default => sub {
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'POC_pastperf_alt' => default => sub {
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'POC_elec' => default => sub {
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'POC_elec_alt' => default => sub {
    Parse::SAMGov::Entity::PointOfContact->new; };
has 'delinquent_fed_debt';
has 'exclusion_status';
has 'is_private';
has 'disaster_response' => default => sub { [] };

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
