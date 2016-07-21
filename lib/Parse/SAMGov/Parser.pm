package Parse::SAMGov::Parser;
use strict;
use warnings;
use 5.010;
use Parse::SAMGov::Parser::Receiver;
use Parse::SAMGov::Parser::Entity;
use Parse::SAMGov::Parser::Exclusion;
use Pegex::Parser;
use Parse::SAMGov::Mo;
use File::Slurper 'read_text';

# ABSTRACT: The Parser class for the files from SAM.gov.

=head1 SYNOPSYS

    my $parser = Parse::SAMGov::Parser->new;
    my $entities = $parser->parse_file(entity => 'SAM_PUBLIC_DAILY_20160701.dat');
    foreach my $e (@$entities) {
        ## do something with each entity
        say $e->DUNS, ' is a valid entity';
    }
    ...
    my $exclusions = $parser->parse_file(exclusion => 'SAM_Exclusions_Public_Extract_16202.CSV');
    foreach my $e (@$exclusions) {
        ## do something with each entity that has been excluded
        say $e->DUNS, ' has been excluded';
    }
    

=method debug

Turn the debug flag on or off during parsing. By default it is off.

=cut

has debug => 0;

has entity_parser => (builder => '_build_entity_parser');
has exclusion_parser => (builder => '_build_exclusion_parser');

sub _build_entity_parser {
    my $self = shift;
    return Pegex::Parser->new(
        grammar => Parse::SAMGov::Parser::Entity->new,
        receiver => Parse::SAMGov::Parser::Receiver->new(debug => $self->debug),
        debug => $self->debug,
        throw_on_error => 0,
    );
}

sub _build_exclusion_parser{
    my $self = shift;
    return Pegex::Parser->new(
        grammar => Parse::SAMGov::Parser::Exclusion->new,
        receiver => Parse::SAMGov::Parser::Receiver->new(debug => $self->debug),
        debug => $self->debug,
        throw_on_error => 0,
    );
}

=method parse_file

This method takes as arguments the type and the file to be parsed and returns an array
reference of Parse::SAMGov::Entity or Parse::SAMGOv::Exclusion objects
depending on the data being parsed. Returns undef if the type is not 'entity' or
'exclusion'. 

    my $entities = $parser->parse_file(entity => 'SAM_PUBLIC_DAILY_20160701.dat');
    my $exclusions = $parser->parse_file(exclusion => 'SAM_Exclusions_Public_Extract_16202.CSV');

=cut

sub parse_file {
    my ($self, $type, $filename) = @_;
    unless ($type =~ /entity|exclusion/i) {
        warn "Invalid Type of file given: $type. Acceptable types are 'entity' and 'exclusion'";
        return;
    }
    my $content = read_text $filename;
    return $self->entity_parser->parse($content) if $type =~ /entity/i;
    return $self->exclusion_parser->parse($content) if $type =~ /exclusion/i;
    return;
}

=method parse_file

This method takes as an argument a file that has the required content to be
parsed. The arguments can specify which file 

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>

