use strict;
use warnings;

use English qw(-no_match_vars);
use Indent::Form;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
eval {
	Indent::Form->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n", "Unknown parameter ''.");

# Test.
eval {
	Indent::Form->new(
		'something' => 'value',
	);
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n",
	"Unknown parameter 'something'.");

# Test.
my $obj = Indent::Form->new;
isa_ok($obj, 'Indent::Form');
