package Indent::Form;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Indent::Word;
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

	# Options.
	$self->{'line_size'} = $LINE_SIZE;
	$self->{'right_align'} = 1;
	$self->{'form_separator'} = ': ';
	$self->{'next_indent'} = undef;

	# Output.
	$self->{'output_separator'} = "\n";

	# Process params.
	set_params($self, @params);

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

	foreach my $dat (@{$data_ar}) {
		my $output = $actual_indent;
		if ($self->{'right_align'}) {
			$output .= $SPACE x ($max - length $dat->[0]);
			$output .= $dat->[0];
		} else {
			$output .= $dat->[0];
			$output .= $SPACE x ($max - length $dat->[0]);
		}
		$output .= $self->{'form_separator'};
		my @tmp = $word->indent($dat->[1]);
		$output .= shift @tmp;
		push @data, $output;
		while (@tmp) {
			push @data, $actual_indent.shift @tmp;
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

=item * B<right_align>

 TODO
 Default value of 'right_align' is 1.

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
         'line_size' parameter must be a number.

 From Class::Utils:
         Unknown parameter '%s'.

=head1 EXAMPLE

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

=head1 DEPENDENCIES

L<Class::Utils(3pm)>,
L<Error::Pure(3pm)>,
L<Indent::Word(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Indent(3pm)>,
L<Indent::Data(3pm)>,
L<Indent::Utils(3pm)>,
L<Indent::Word(3pm)>.

=head1 AUTHOR

Michal Špaček <F<skim@cpan.org>>.

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
