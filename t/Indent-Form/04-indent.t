use strict;
use warnings;

use English qw(-no_match_vars);
use Indent::Form;
use Test::More 'tests' => 8;
use Test::NoWarnings;

# Test.
my $obj = Indent::Form->new(
	'line_size' => 80,
	'output_separator' => "\n",
);
my $input = [
        ['Login', 'Michal Spacek'],
        ['Password', 'abcdefghijklmnopqrstuvw'],
        ['Info', 'This is big info.'],
];
my @right_ret = (
	'   Login: Michal Spacek',
	'Password: abcdefghijklmnopqrstuvw',
	'    Info: This is big info.',
);
my @ret = $obj->indent($input);
is_deeply(\@ret, \@right_ret, 'Default indent.');

# Test.
$obj = Indent::Form->new;
$input = [
        ['Login', 'Michal Spacek'],
        ['Password', 'abcdefghijklmnopqrstuvw'],
        ['Info', 'This is big info.'],
];
@right_ret = (
	'Foo:    Login: Michal Spacek',
	'Foo: Password: abcdefghijklmnopqrstuvw',
	'Foo:     Info: This is big info.',
);
@ret = $obj->indent($input, 'Foo: ');
is_deeply(\@ret, \@right_ret, 'Indent with local prefix.');

# Test.
$obj = Indent::Form->new(
	'line_size' => 10,
	'output_separator' => "\n",
);
@right_ret = (
	'   Login: Michal',
	'          Spacek',
	'Password: abcdefghijklmnopqrstuvw',
	'    Info: This',
	'          is',
	'          big',
	'          info.',
);
@ret = $obj->indent($input);
is_deeply(\@ret, \@right_ret, 'Indent with smaller line size (10).');

# Test.
eval {
	Indent::Form->new(
		'next_indent' => '  ',
		'line_size' => 'ko',
	);
};
is($EVAL_ERROR, "'line_size' parameter must be a number.\n",
	"Error with bad 'line_size' parameter.");

# Test.
$obj = Indent::Form->new;
$input = [
	[undef, 'value'],
];
@right_ret = (
	': value',
);
@ret = $obj->indent($input);
is_deeply(\@ret, \@right_ret, 'Indent with undef in first column.');

# Test.
$obj = Indent::Form->new;
$input = [
	['value', undef],
];
@right_ret = (
	'value',
);
@ret = $obj->indent($input);
is_deeply(\@ret, \@right_ret, 'Indent with undef in second column.');

# Test.
# TODO non-sense second line.
$obj = Indent::Form->new;
$input = [
	['key', 'value'],
	[undef, undef],
	['key', 'value'],
];
@right_ret = (
	'key: value',
	'   ',
	'key: value',
);
@ret = $obj->indent($input);
is_deeply(\@ret, \@right_ret, 'Indent with undef in both columns.');
