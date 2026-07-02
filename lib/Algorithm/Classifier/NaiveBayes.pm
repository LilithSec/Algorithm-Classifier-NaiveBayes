package Algorithm::Classifier::NaiveBayes;

use 5.006;
use strict;
use warnings;

=head1 NAME

Algorithm::Classifier::NaiveBayes - 

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Algorithm::Classifier::NaiveBayes;

    my $foo = Algorithm::Classifier::NaiveBayes->new();
    ...

=head1 METHODS

=head2 new

Initiates the object.

=cut

sub new {
	my $self = {
		'model' => {
			'class_counts'   => {},
			'token_counts'   => {},
			'class_totals'   => {},
			'token'          => {},
			'total_docs'     => 0,
			'lc_tokens'      => 1,
			'token_splitter' => '\s',
			'stop_regex'     => undef,
		},
	};
	bless $self;

	return $self;
} ## end sub new

=head2 tokenize

Tokenizes the the specified string.

    my @tokens = $nb->tokenize($string);

=cut

sub tokenize {
	my ( $self, $text ) = @_;
	my $split_regex = $self->{'model'}{'token_splitter'};
	my @tokens      = split( /$split_regex/, $text );
	my @final_tokens;
	foreach my $token (@tokens) {
		if ( $self->{'model'}{'lc_tokens'} ) {
			$token = lc($token);
		}
		my $add_token=1;
		if (defined($self->{'model'}{'stop_regex'})){
			my $stop_regex=$self->{'model'}{'stop_regex'};
			if ($token =~ /$stop_regex/){
				$add_token=0;
			}
		}
		if ($add_token){
			push( @final_tokens, $token );
		}
	}
	return @final_tokens;
} ## end sub tokenize

=head2 train

Train a specific class on the specified string.

    $nb->train($class, $string);

=cut

sub train {
	my ( $self, $class, $text ) = @_;
	$self->{'model'}{'class_counts'}{$class}++;
	$self->{'model'}{'total_docs'}++;
	if ( !defined( $self->{'model'}{'token_counts'}{$class} ) ) {
		$self->{'model'}{'token_counts'}{$class} = {};
	}
	if ( !defined( $self->{'model'}{'class_totals'}{$class} ) ) {
		$self->{'model'}{'class_totals'}{$class} = 0;
	}
	for my $word ( $self->tokenize($text) ) {
		$self->{'model'}{'token_counts'}{$class}{$word}++;
		$self->{'model'}{'class_totals'}{$class}++;
		$self->{'model'}{'tokens'}{$word} = 1;
	}
} ## end sub train

=head2 classify

Classify the text in question.

    my $class = $nb->classify($text);

=cut

sub classify {
	my ( $self, $text ) = @_;
	my @tokens     = $self->tokenize($text);
	my $token_size = scalar keys %{ $self->{'model'}{'tokens'} };

	my %scores;
	for my $class ( keys %{ $self->{'model'}{'class_counts'} } ) {
		my $log_prob = log( $self->{'model'}{'class_counts'}{$class} / $self->{'model'}{'total_docs'} );
		my $total    = $self->{'model'}{'class_totals'}{$class} || 0;

		for my $token (@tokens) {
			my $count = $self->{'model'}{'token_counts'}{$class}{$token} || 0;
			$log_prob += log( ( $count + 1 ) / ( $total + $token_size ) );
		}
		$scores{$class} = $log_prob;
	} ## end for my $class ( keys %{ $self->{'model'}{'class_counts'...}})

	my ($best) = sort { $scores{$b} <=> $scores{$a} } keys %scores;
	return wantarray ? ( $best, \%scores ) : $best;
} ## end sub classify

=head1 AUTHOR

Zane C. Bowers-Hadley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-algorithm-classifier-naivebayes at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Algorithm-Classifier-NaiveBayes>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::Classifier::NaiveBayes


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-Classifier-NaiveBayes>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Algorithm-Classifier-NaiveBayes>

=item * Search CPAN

L<https://metacpan.org/release/Algorithm-Classifier-NaiveBayes>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2026 by Zane C. Bowers-Hadley.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999


=cut

1;    # End of Algorithm::Classifier::NaiveBayes
