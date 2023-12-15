#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use feature 'say';
use Parse::SAMGov;
use Getopt::Long;
use Text::CSV_XS;
binmode STDOUT, ':utf8';
$| = 1;

sub usage {
    my $app = shift;
    return <<EOF
Usage: $app --help | --input=<filename> | --output=<filename> | --smallbiz | --largebiz

--help                    This help message
--input=<filename>        The input filename from www.sam.gov. Required.
--output=<filename>       The output CSV filename to use. Required.
--smallbiz                Only dump the small businesses. Default dumps all.
--largebiz                Only dump the large businesses. Default dumps all.
EOF
}

my ($help, $infile, $smallbiz, $largebiz, $outfile);
GetOptions("input=s" => \$infile, "help" => \$help,
    "smallbiz" => \$smallbiz, "largebiz" => \$largebiz,
    "output=s" => \$outfile,
) or die usage($0);
die usage($0) if $help or not $infile or not $outfile;

my $parser = Parse::SAMGov->new;

### we want to filter NAICS 541511, 541512, 541519, 541715
### which are NAICS codes for software development
### write to CSV
my $csv = Text::CSV_XS->new({ binary => 1, auto_diag => 1 });
open my $fh, ">:encoding(utf8)", $outfile or die "$outfile: $!";
my @columns = (
'UEI',
'Company Name',
'DBA Name',
'Website',
'City',
'State',
'Country',
'Founding Date',
'EPOC Name',
'EPOC Email',
'EPOC Title',
'GPOC Name',
'GPOC Email',
'GPOC Title',
);
$csv->column_names(@columns);
$csv->say($fh, \@columns);
my $entities = $parser->parse_file($infile, sub {
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
            my $poc_elec = $e->POC_elec;
            my $poc_gov = $e->POC_gov;
            ## skip all non-USA with no websites
            if (defined $url and length($url)
                    and ref $e->physical_address eq 'Parse::SAMGov::Entity::Address'
                    and uc($e->physical_address->country) eq 'USA') {
                $csv->say($fh,
                        [$e->UEI, $e->name, $e->dba_name, $url, $e->physical_address->city,
                        $e->physical_address->state, $e->physical_address->country,
                        $e->start_date->ymd('-'),
                        $poc_elec->name,
                        $poc_elec->email,
                        $poc_elec->title,
                        $poc_gov->name,
                        $poc_gov->email,
                        $poc_gov->title,
                        ]);
                return 1;
            }
        }
        return undef;
    });
close $fh or die "$outfile: $!";

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
