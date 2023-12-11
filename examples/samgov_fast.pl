#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use feature 'say';
use Parse::SAMGov;
use Getopt::Long;
binmode STDOUT, ':utf8';
$| = 1;
STDOUT->autoflush(1);

sub usage {
    my $app = shift;
    return <<EOF
Usage: $app --help | --file=<filename> | --smallbiz | --largebiz

--help                    This help message
--file=<filename>         The input filename from www.sam.gov
--smallbiz                Only dump the small businesses. Default dumps all.
--largebiz                Only dump the large businesses. Default dumps all.
EOF
}

my ($help, $filename, $smallbiz, $largebiz);
GetOptions("file=s" => \$filename, "help" => \$help,
    "smallbiz" => \$smallbiz, "largebiz" => \$largebiz,
) or die usage($0);
die usage($0) if $help or not $filename;

my $parser = Parse::SAMGov->new;

### we want to filter NAICS 541511, 541512, 541519, 541715
### which are NAICS codes for software development
my $entities = $parser->parse_file($filename, sub {
        # want smallbiz only but isn't smallbiz
        return undef if (!$largebiz && $smallbiz && !$_[0]->is_smallbiz);
        # want largebiz only but isn't largebiz
        return undef if (!$smallbiz && $largebiz && $_[0]->is_smallbiz);
        # want anything that matches criteria
        my $naics = $_[0]->NAICS;
        my $key_exists = 0;
        foreach (qw(541511 541512 541519 541715)) {
            $key_exists++ if $naics->{$_};
        }
        if ($key_exists) {
            my $e = $_[0];
            my $company = $e->name;
            $company .= ' dba ' . $e->dba_name if length $e->dba_name;
            print STDERR "Found $company for you\n";
            my $url = $e->url;
            ## skip all non-USA with no websites
            if (defined $url and length($url)
                    and ref $e->physical_address eq 'Parse::SAMGov::Entity::Address'
                    and uc($e->physical_address->country) eq 'USA') {
                say join(',', $e->UEI, $company, $url, $e->physical_address->city,
                        $e->physical_address->state, $e->physical_address->country,
                        $e->start_date->ymd('-'));
                return 1;
            }
        }
        return undef;
    });

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
