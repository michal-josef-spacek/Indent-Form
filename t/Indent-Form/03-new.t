use strict;
use warnings;

use English qw(-no_match_vars);
use Indent::Form;
use Test::More 'tests' => 5;
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
eval {
	Indent::Form->new(
		'align' => 'bad_align',
	);
};
is($EVAL_ERROR, "'align' parameter must be a 'left' or 'right' string.\n",
	"'align' parameter must be a 'left' or 'right' string.");

# Test.
my $obj = Indent::Form->new;
isa_ok($obj, 'Indent::Form');
