use Test::More;

use_ok('Parse::SAMGov::Entity');

my $e = new_ok('Parse::SAMGov::Entity');
can_ok(
    $e, qw( DUNS DUNSplus4 CAGE
      ));

done_testing();
__END__
### COPYRIGHT: Selective Intellect LLC.
### AUTHOR: Vikas N Kumar <vikas@cpan.org>
