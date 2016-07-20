package Parse::SAMGov::Exclusion;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;
use DateTime;
use Parse::SAMGov::Exclusion::Name;
use Parse::SAMGov::Exclusion::Address;

has classification => ();
has name => default => sub {
    return Parse::SAMGov::Exclusion::Name->new;
};
has address => default => sub {
    return Parse::SAMGov::Exclusion::Address->new;
};
has 'DUNS';
has 'program';
has 'agency';
has 'CT_code';
has 'type';
has 'comments';
has 'active_date'      => default => sub { return DateTime->now; };
has 'termination_date' => default => sub { return DateTime->now; };
has 'record_status';
has 'crossref';
has 'SAM_number';
has 'CAGE';
has 'NPI';
1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
