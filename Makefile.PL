# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Špaček <skim@cpan.org>',
	'BUILD_REQUIRES' => {
		'English' => 0,
		'File::Object' => 0,
		'Test::More' => 0,
		'Test::Pod' => 0,
		'Test::Pod::Coverage' => 0,
	},
	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker' => 0,
	},
	'NAME' => 'Indent::Form',
	'PREREQ_PM' => {
		'Class::Utils' => 0.01,
		'Error::Pure' => 0.01,
		'Indent::Word' => 0.01,
		'Readonly' => 0,
	},
	'VERSION' => 0.01,
	'test' => {
		'TESTS' => 't/Indent::Form/*.t',
	},
);
