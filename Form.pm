package Indent::Form;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Indent::Word;
use List::MoreUtils qw(none);
use Readonly;

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $LINE_SIZE => 79;
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Align.
	$self->{'align'} = 'right';

	# Fill character.
	$self->{'fill_character'} = $SPACE;

	# Line size.
	$self->{'line_size'} = $LINE_SIZE;

	# Form separator.
	$self->{'form_separator'} = ': ';

	# Next indent.
	$self->{'next_indent'} = undef;

	# Output.
	$self->{'output_separator'} = "\n";

	# Process params.
	set_params($self, @params);

	# Check align.
	if (none { $self->{'align'} eq $_ } qw(left right)) {
		err '\'align\' parameter must be a \'left\' or \'right\' '.
			'string.';
	}

	# 'line_size' check.
	if ($self->{'line_size'} !~ /^\d*$/ms || $self->{'line_size'} < 0) {
		err '\'line_size\' parameter must be a number.', 
			'line_size', $self->{'line_size'};
	}

	# Object.
	return $self;
}

# Indent form data.
sub indent {
	my ($self, $data_ar, $actual_indent, $non_indent_flag) = @_;

	# Undef indent.
	if (! $actual_indent) {
		$actual_indent = $EMPTY_STR;
	}

	# Max size of key.
	my $max = 0;
	my @data;
	foreach my $dat (@{$data_ar}) {
		if (length $dat->[0] > $max) {
			$max = length $dat->[0];
		}

		# Non-indent.
		if ($non_indent_flag) {
			push @data, $dat->[0].$self->{'form_separator'}.
				$dat->[1];
		}
	}

	# If non-indent.
	# Return as array or one line with output separator between its.
	if ($non_indent_flag) {
		return wantarray ? @data
			: join $self->{'output_separator'}, @data;
	}

	# Indent word.
	my $next_indent = $self->{'next_indent'} ? $self->{'next_indent'}
		: $SPACE x ($max + length $self->{'form_separator'});
	my $word = Indent::Word->new(
		'line_size' => $self->{'line_size'} - $max
			- length $self->{'form_separator'},
		'next_indent' => $next_indent,
	);

	foreach my $dat_ar (@{$data_ar}) {
		my $output = $actual_indent;

		# Left side.
		if ($self->{'align'} eq 'left') {
			$output .= $dat_ar->[0];
			$output .= $self->{'fill_character'}
				x ($max - length $dat_ar->[0]);
		} elsif ($self->{'align'} eq 'right') {
			$output .= $self->{'fill_character'}
				x ($max - length $dat_ar->[0]);
			$output .= $dat_ar->[0];
		}

		# Right side.
		if ($dat_ar->[1]) {
			$output .= $self->{'form_separator'};
			my @tmp = $word->indent($dat_ar->[1]);
			$output .= shift @tmp;
			push @data, $output;
			while (@tmp) {
				push @data, $actual_indent.shift @tmp;
			}
		} else {
			push @data, $output;
		}
	}

	# Return as array or one line with output separator between its.
	return wantarray ? @data : join $self->{'output_separator'}, @data;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Indent::Form - A perl module for form indenting.

=head1 SYNOPSIS

 use Indent::Form;
 my $indent = Indent::Form->new(%parametes);
 $indent->indent($data_ar, $actual_indent, $non_indent_flag);

=head1 METHODS

=over 8

=item B<new(%params)>

 Constructor.

=over 8

=item * B<align>

 Align of left side of form.
 Default value is 'right'.

=item * B<fill_character>

 Fill character for left side of form.
 Default value is ' '.

=item * B<form_separator>

 TODO
 Default value of 'form_separator' is ': '.

=item * B<line_size>

 TODO
 Default value of 'line_size' is 79 chars.

=item * B<next_indent>

 TODO
 Default value of 'next_indent' isn't define.

=item * B<output_separator>

 TODO
 Default value of 'output_separator' is new line (\n).

=back

=item B<indent($data_ar[, $actual_indent, $non_indent_flag])>

 Indent data. Returns string.

 Arguments:
 $data_ar - Reference to data array ([['key' => 'value'], [..]]);
 $actual_indent - String to actual indent.
 $non_indent_flag - Flag, than says no-indent.

=back

=head1 ERRORS

 Mine:
         'align' parameter must be a 'left' or 'right' string.
         'line_size' parameter must be a number.

 From Class::Utils:
         Unknown parameter '%s'.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Indent::Form;

 # Indent object.
 my $indent = Indent::Form->new;

 # Input data.
 my $input_ar = [
         ['Filename', 'foo.bar'],
         ['Size', '1456kB'],
         ['Description', 'File'],
         ['Author', 'skim.cz'],
 ];

 # Indent.
 print $indent->indent($input_ar)."\n";

 # Output:
 #    Filename: foo.bar
 #        Size: 1456kB
 # Description: File
 #      Author: skim.cz

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Indent::Form;

 # Indent object.
 my $indent = Indent::Form->new(
         'align' => 'left',
 );

 # Input data.
 my $input_ar = [
         ['Filename', 'foo.bar'],
         ['Size', '1456kB'],
         ['Description', 'File'],
         ['Author', 'skim.cz'],
 ];

 # Indent.
 print $indent->indent($input_ar)."\n";

 # Output:
 # Filename   : foo.bar
 # Size       : 1456kB
 # Description: File
 # Author     : skim.cz

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Indent::Form;

 # Indent object.
 my $indent = Indent::Form->new(
         'align' => 'left',
         'fill_character' => '.',
 );

 # Input data.
 my $input_ar = [
         ['Filename', 'foo.bar'],
         ['Size', '1456kB'],
         ['Description', 'File'],
         ['Author', 'skim.cz'],
 ];

 # Indent.
 print $indent->indent($input_ar)."\n";

 # Output:
 # Filename...: foo.bar
 # Size.......: 1456kB
 # Description: File
 # Author.....: skim.cz

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<Error::Pure(3pm)>,
L<Indent::Word(3pm)>,
L<List::MoreUtils(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Indent(3pm)>,
L<Indent::Data(3pm)>,
L<Indent::Utils(3pm)>,
L<Indent::Word(3pm)>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
