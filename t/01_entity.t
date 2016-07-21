use Test::More;

use_ok('Parse::SAMGov::Entity');

my $e = new_ok('Parse::SAMGov::Entity');
can_ok(
    $e, qw( DUNS DUNSplus4 CAGE DODAAC
    reg_purpose reg_date
      ));
isa_ok($e->reg_date('20160101'), 'DateTime');
is($e->reg_date->ymd('/'), '2016/01/01', 'registration date matches');


done_testing();
__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
