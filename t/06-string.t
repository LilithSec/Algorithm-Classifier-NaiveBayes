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

my $json = $nb->to_string;
like( $json, qr/"class_counts"/, 'to_string returns JSON' );
like( $json, qr/"format"\s*:\s*"Algorithm::Classifier::NaiveBayes"/, 'to_string includes the format' );
like( $json, qr/"version"\s*:\s*1/, 'to_string includes the model version' );

my $from = Algorithm::Classifier::NaiveBayes->new;
$from->from_string($json);
is_deeply( $from->{'model'}, $nb->{'model'}, 'from_string round trips the model' );
is( $from->classify('buy cheap pills'), 'spam', 'from_string model classifies' );

eval { $from->from_string(); };
like( $@, qr/No string specified/, 'from_string with no string dies' );

eval { $from->from_string('this is not json'); };
like( $@, qr/as JSON/, 'from_string with non-JSON dies' );

# format and version checking
my $base_model
	= '"class_counts":{},"token_counts":{},"class_totals":{},"tokens":{},"total_docs":0,"token_splitter":"\\\\s+"';

eval { $from->from_string( '{' . $base_model . '}' ); };
like( $@, qr/"format" is not/, 'from_string with a missing format dies' );

eval { $from->from_string( '{"format":"Some::Other::Module","version":1,' . $base_model . '}' ); };
like( $@, qr/"format" is not/, 'from_string with a wrong format dies' );

eval { $from->from_string( '{"format":"Algorithm::Classifier::NaiveBayes","version":"x",' . $base_model . '}' ); };
like( $@, qr/"version" is not a int/, 'from_string with a non-numeric version dies' );

eval { $from->from_string( '{"format":"Algorithm::Classifier::NaiveBayes","version":2,' . $base_model . '}' ); };
like( $@, qr/newer than the highest supported/, 'from_string with a too new version dies' );

eval { $from->from_string( '{"format":"Algorithm::Classifier::NaiveBayes","version":1,' . $base_model . '}' ); };
is( $@, '', 'from_string with a good format and version works' );

done_testing;
