package Parse::SAMGov;

# ABSTRACT: Parses SAM Entity Management Public Extract Layout from SAM.gov

use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Entity;
use Parse::SAMGov::Exclusion;
use Parse::SAMGov::Parser;
use Parse::SAMGov::Mo;

has parser => default => sub {
    return Parse::SAMGov::Parser->new;
};

sub parse_file {
    return shift->parser->parse_file(@_);
}

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
