use Test::More;

use_ok('Parse::SAMGov::Exclusion');

my $e = new_ok('Parse::SAMGov::Exclusion');
can_ok ($e, qw( DUNS CAGE name address classification
    ));
my $name = $e->name;
isa_ok($name, 'Parse::SAMGov::Exclusion::Name');
can_ok($name, qw(first middle last suffix prefix entity));
my $address = $e->address;
isa_ok($address, 'Parse::SAMGov::Exclusion::Address');
can_ok($address, qw(address city state zip country));
isa_ok($address->address, 'ARRAY');


done_testing();
__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>

