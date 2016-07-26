package Parse::SAMGov;

use strict;
use warnings;
use 5.010;
use Carp;
use IO::All;
use Text::CSV_XS;
use Parse::SAMGov::Entity;
use Parse::SAMGov::Exclusion;
use Parse::SAMGov::Mo;

# ABSTRACT: Parses SAM Entity Management Public Extract Layout from SAM.gov

=head1 SYNOPSIS

    my $parser = Parse::SAMGov::Parser->new;
    my $entities = $parser->parse_file(entity => 'SAM_PUBLIC_DAILY_20160701.dat');
    foreach my $e (@$entities) {
        ## do something with each entity
        say $e->DUNS, ' is a valid entity';
    }
    # ... do something ...
    my $exclusions = $parser->parse_file(exclusion => 'SAM_Exclusions_Public_Extract_16202.CSV');
    foreach my $e (@$exclusions) {
        ## do something with each entity that has been excluded
        say $e->DUNS, ' has been excluded';
    }
    

=method parse_file

This method takes as arguments the file to be parsed and returns an array
reference of L<Parse::SAMGov::Entity> or L<Parse::SAMGOv::Exclusion> objects
depending on the data being parsed. Returns undef if the type is not 'entity' or
'exclusion'. If the third argument is a coderef then passes each Entity or
Exclusion object into the callback instead rather than returning it. This can be
useful for a lower memory footprint if the file to parse is large or if the user
wants to write a filter that only picks entities they're interested in. The
function returns an array reference only if the callback mode is not used.

    my $entities = $parser->parse_file('SAM_PUBLIC_DAILY_20160701.dat');
    my $exclusions = $parser->parse_file('SAM_Exclusions_Public_Extract_16202.CSV');
    $parser->parse_file('SAM_PUBLIC_DAILY_20160701.dat', sub {
        my ($entity_or_exclusion, $optional_user_arg) = @_;
        #... do something ...
    }, $optional_user_arg);


=head1 SEE ALSO

L<Parse::SAMGov::Entity> and L<Parse::SAMGov::Exclusion> for the object
definitions.

=cut

sub parse_file {
    my ($self, $filename, $cb, $cb_arg) = @_;
    croak "Unable to open file $filename: $!" unless -e $filename;
    my $io = io $filename;
    croak "Unable to create IO::All object for reading $filename"
      unless defined $io;
    my $result      = [];
    my $is_entity   = 0;
    my $entity_info = {};
    while (my $line = $io->getline) {
        chomp $line;
        $line =~ s/^\s+//g;
        $line =~ s/\s+$//g;
        next unless length $line;
        my $obj = Parse::SAMGov::Entity->new;
        if ($line =~ /BOF PUBLIC\s+(\d{8})\s+(\d{8})\s+(\d+)\s+(\d+)/) {
            $is_entity            = 1;
            $entity_info->{date}  = $1;
            $entity_info->{rows}  = $3;
            $entity_info->{seqno} = $4;
            next;
        } elsif ($line =~ /EOF\s+PUBLIC\s+(\d{8})\s+(\d{8})\s+(\d+)\s+(\d+)/) {
            croak "Invalid footer q{$line} in file"
              if (   $entity_info->{date} ne $1
                  or $entity_info->{rows}  ne $3
                  or $entity_info->{seqno} ne $4);
            last;
        } else {
            last unless $is_entity;    # skip this loop and do something else
            my @data = split /\|/x, $line;
            carp "Invalid data line \n$line\n" unless $obj->load(@data);
        }
        if (defined $cb and ref $cb eq 'CODE') {
            &$cb($obj, $cb_arg);
        } else {
            push @$result, $obj;
        }
    }
    unless ($is_entity) {
        my $csv = Text::CSV_XS->new({ binary => 1 })
          or croak "Failed to create Text::CSV_XS object: "
          . Text::CSV_XS->error_diag();
        my $obj = Parse::SAMGov::Exclusion->new;
        while (my $row = $csv->getline($io->io_handle)) {
            carp "Invalid data line \n$row\n" unless $obj->load(@$row);
            if (defined $cb and ref $cb eq 'CODE') {
                &$cb($obj, $cb_arg);
            } else {
                push @$result, $obj;
            }
        }
        $csv->eof or $csv->error_diag();
    }
    return $result if scalar @$result;
    return;
}

1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
