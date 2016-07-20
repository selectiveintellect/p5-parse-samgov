use strict;
use warnings;
use 5.010;
{
    package Parse::SAMGov::Exclusion::Name;
    use Parse::SAMGov::Mo;
    
    has 'prefix';
    has 'first';
    has 'middle';
    has 'last';
    has 'suffix';
    has 'entity';
}
{
    package Parse::SAMGov::Exclusion::Address;
    use Parse::SAMGov::Mo;
    
    has 'address' => [];
    has 'city';
    has 'state';
    has 'zip';
    has 'country';
}
{
    package Parse::SAMGov::Exclusion;
    use Parse::SAMGov::Mo;

    has classification => ();
    has name => default => sub {
        return Parse::SAMGov::Exclusion::Name->new;
    };
    has address => default => sub {
        return Parse::SAMGov::Exclusion::Address->new;
    };
    has 'DUNS';
    has 'CAGE';
}
1;

__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
