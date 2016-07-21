package Parse::SAMGov::Entity;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Mo;

#ABSTRACT: Object to denote each Entity in SAM

has DUNS      => ();
has DUNSplus4 => default => sub { '0000' };
has CAGE      => ();

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
