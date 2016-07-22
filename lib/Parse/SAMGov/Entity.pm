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
use Carp;

#ABSTRACT: Object to denote each Entity in SAM

use overload fallback => 1,
    '""' => sub {
        my $self = $_[0];
        my $str = '';
        $str .= $self->name if $self->name;
        $str .= ' dba ' . $self->dba_name if $self->dba_name;
        $str .= "\nDUNS: " . $self->DUNS if $self->DUNS;
        $str .= '+' . $self->DUNSplus4 if $self->DUNSplus4 ne '0000';
        $str .= "\nCAGE: " . $self->CAGE if $self->CAGE;
        $str .= "\nDODAAC: " . $self->DODAAC if $self->DODAAC;
        $str .= "\nStatus: " . $self->extract_code if $self->extract_code;
        $str .= "\nUpdated: Yes" if $self->updated;
        $str .= "\nRegistration Purpose: " . $self->regn_purpose if $self->regn_purpose;
        $str .= "\nRegistration Date: " . $self->regn_date->ymd('-') if $self->regn_date;
        $str .= "\nExpiry Date: " . $self->expiry_date->ymd('-') if $self->expiry_date;
        $str .= "\nLast Update Date: " . $self->lastupdate_date->ymd('-') if $self->lastupdate_date;
        $str .= "\nActivation Date: " . $self->activation_date->ymd('-') if $self->activation_date;
        $str .= "\nCompany Division: " . $self->company_division if $self->company_division;
        $str .= "\nDivision No.: " . $self->division_no if $self->division_no;
        $str .= "\nPhysical Address: " . $self->physical_address;
        return $str;
    };

=head1 SYNOPSIS

    my $e = Parse::SAMGov::Entity->new(DUNS => 12345);
    say $e; #... stringification supported ...

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

This denotes whether the SAM entry is active or expired
during extraction of the data.

=method updated

This denotes whether the SAM entry has been updated recently. Has a boolean
value of 1 if updated and 0 or undef otherwise.

=method regn_purpose

This denotes whether the purpose of registration is Federal Assistance Awards,
All Awards, IGT-only, Federal Assistance Awards & IGT or All Awards & IGT.

=cut

has 'extract_code';
has 'updated';
has 'regn_purpose' => coerce => sub {
    my $p = $_[0];
    return 'Federal Assistance Awards' if $p eq 'Z1';
    return 'All Awards' if $p eq 'Z2';
    return 'IGT-Only' if $p eq 'Z3';
    return 'Federal Assistance Awards & IGT' if $p eq 'Z4';
    return 'All Awards & IGT' if $p eq 'Z5';
};

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

sub load {
    my $self = shift;
    my @data = @_;
    use Data::Dumper;
#    say STDERR Dumper(\@data);
    return unless (scalar(@data) == 150);
    $self->DUNS($data[0]);
    $self->DUNSplus4($data[1]) if $data[1];
    $self->CAGE($data[2]) if $data[2];
    $self->DODAAC($data[3]) if $data[3];
    $self->updated(0);
    if ($data[4] =~ /A|2|3/x) {
        $self->extract_code('active');
        $self->updated(1) if $data[4] eq '3';
    } elsif ($data[4] =~ /E|1|4/x) {
        $self->extract_code('expired');
        $self->updated(1) if $data[4] eq '1';
    }
    $self->regn_purpose($data[5]) if $data[5];
    $self->regn_date($data[6]) if $data[6];
    $self->expiry_date($data[7]) if $data[7];
    $self->lastupdate_date($data[8]) if $data[8];
    $self->activation_date($data[9]) if $data[9];
    $self->name($data[10]) if $data[10];
    $self->dba_name($data[11]) if $data[11];
    $self->company_division($data[12]) if $data[12];
    $self->division_number($data[13]) if $data[13];
    my $paddr = Parse::SAMGov::Entity::Address->new(
        address => join(", ", $data[14], $data[15]),
        city => $data[16],
        state => $data[17],
        zip => ($data[19] ? "$data[18]-$data[19]" : $data[18]),
        country => $data[20],
        district => $data[21],
    );
    $self->physical_address($paddr);

    1;
}

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
