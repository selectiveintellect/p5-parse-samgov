package Parse::SAMGov::Parser::Receiver;
use strict;
use warnings;
use 5.010;
use feature 'say';

#ABSTRACT: The Receiver class for the parser.

use Pegex::Base;
extends 'Pegex::Tree';

use Parse::SAMGov::Entity;
use Parse::SAMGov::Exclusion;

has debug => 0;

sub final {
    my ($self, $got) = @_;
    return $got;
}

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
