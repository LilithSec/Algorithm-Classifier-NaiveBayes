#!perl
# A minimal example. Trains a classifier with a few spam and ham
# examples and then classifies some new strings.
use strict;
use warnings;
use Algorithm::Classifier::NaiveBayes;

my $nb = Algorithm::Classifier::NaiveBayes->new;

$nb->train( 'spam', 'buy cheap pills now' );
$nb->train( 'spam', 'cheap watches for sale' );
$nb->train( 'spam', 'you have won a free cruise' );
$nb->train( 'ham',  'meeting at noon tomorrow' );
$nb->train( 'ham',  'lunch with the team' );
$nb->train( 'ham',  'the report is attached' );

my @to_classify = ( 'cheap pills for sale', 'can we move the meeting to after lunch', 'you have won free pills', );

foreach my $text (@to_classify) {
	my ( $class, $scores ) = $nb->classify($text);
	print '"' . $text . '" -> ' . $class . "\n";
	foreach my $possible ( sort { $scores->{$b} <=> $scores->{$a} } keys %{$scores} ) {
		print '    ' . $possible . ': ' . $scores->{$possible} . "\n";
	}
}
