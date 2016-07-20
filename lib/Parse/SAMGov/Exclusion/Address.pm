package Parse::SAMGov::Exclusion::Address;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;

has 'address' => [];
has 'city';
has 'state';
has 'zip';
has 'country';

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
