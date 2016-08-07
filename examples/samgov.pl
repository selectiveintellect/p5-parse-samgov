#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Parse::SAMGov;
use Getopt::Long;

sub usage {
    my $app = shift;
    return <<EOF
Usage: $app --help | --file=<filename>
EOF
}

my ($help, $filename);
GetOptions("file=s" => \$filename, "help" => \$help) or die usage($0);
die usage($0) if $help or not $filename;

my $parser = Parse::SAMGov->new;

### we want to filter NAICS 541511, 541512, 541519, 541712
### which are NAICS codes for software development
my $entities = $parser->parse_file($filename, sub {
        return 1 if $_[0]->NAICS->{541511};
        return 1 if $_[0]->NAICS->{541512};
        return 1 if $_[0]->NAICS->{541519};
        return 1 if $_[0]->NAICS->{541712};
        return undef;
    });

die "No entities found" unless scalar @$entities;

foreach my $e (@$entities) {
    say join(',', $e->POC_elec->name, $e->POC_elec->email);
}


__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
