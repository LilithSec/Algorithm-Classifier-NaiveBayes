#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

use Algorithm::Classifier::NaiveBayes;

my $nb = Algorithm::Classifier::NaiveBayes->new;
$nb->train( 'spam', 'buy cheap pills now cheap' );
$nb->train( 'ham',  'meeting at noon tomorrow' );
$nb->train( 'ham',  'lunch meeting tomorrow' );

is( $nb->classify('buy cheap pills'),       'spam', 'classifies spam' );
is( $nb->classify('meeting noon tomorrow'), 'ham',  'classifies ham' );

my ( $best, $scores ) = $nb->classify('cheap pills');
is( $best, 'spam', 'list context returns best class' );
is( ref($scores), 'HASH', 'list context returns scores hashref' );
is_deeply( [ sort keys %{$scores} ], [ 'ham', 'spam' ], 'scores has an entry per class' );
ok( $scores->{'spam'} > $scores->{'ham'}, 'winning class has the highest score' );
ok( $scores->{'spam'} < 0, 'scores are log probabilities' );

# unseen tokens are smoothed rather than dying
my $unseen = $nb->classify('zebra quantum');
ok( defined($unseen), 'classify handles entirely unseen tokens' );

# untrained model
my $empty = Algorithm::Classifier::NaiveBayes->new;
is( $empty->classify('anything'), undef, 'untrained classify returns undef' );
my ( $ebest, $escores ) = $empty->classify('anything');
is( $ebest, undef, 'untrained classify returns undef in list context' );
is_deeply( $escores, {}, 'untrained classify returns empty scores' );

# tie breaking is deterministic
my $tie = Algorithm::Classifier::NaiveBayes->new;
$tie->train( 'b', 'foo' );
$tie->train( 'a', 'foo' );
is( $tie->classify('foo'), 'a', 'ties break deterministically by class name' );

done_testing;
