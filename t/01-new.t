#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

use Algorithm::Classifier::NaiveBayes;

my $nb = Algorithm::Classifier::NaiveBayes->new;
isa_ok( $nb, 'Algorithm::Classifier::NaiveBayes', 'new' );
is( $nb->{'model'}{'lc_tokens'},      1,     'lc_tokens defaults to 1' );
is( $nb->{'model'}{'token_splitter'}, '\s+', 'token_splitter defaults to \s+' );
is( $nb->{'model'}{'stop_regex'},     undef, 'stop_regex defaults to undef' );
is( $nb->{'model'}{'total_docs'},     0,     'total_docs starts at 0' );

my $nb_args = Algorithm::Classifier::NaiveBayes->new(
	'lc_tokens'      => 0,
	'token_splitter' => ',',
	'stop_regex'     => 'foo',
);
is( $nb_args->{'model'}{'lc_tokens'},      0,     'lc_tokens arg is used' );
is( $nb_args->{'model'}{'token_splitter'}, ',',   'token_splitter arg is used' );
is( $nb_args->{'model'}{'stop_regex'},     'foo', 'stop_regex arg is used' );

# arg sanity checking
eval { Algorithm::Classifier::NaiveBayes->new( 'derp' => 1 ); };
like( $@, qr/not a known arg/, 'unknown args die' );

eval { Algorithm::Classifier::NaiveBayes->new( 'token_splitter' => '(' ); };
like( $@, qr/does not compile/, 'non-compiling token_splitter dies' );

eval { Algorithm::Classifier::NaiveBayes->new( 'stop_regex' => '[a-' ); };
like( $@, qr/does not compile/, 'non-compiling stop_regex dies' );

eval { Algorithm::Classifier::NaiveBayes->new( 'token_splitter' => '' ); };
like( $@, qr/empty string/, 'empty token_splitter dies' );

eval { Algorithm::Classifier::NaiveBayes->new( 'stop_regex' => [] ); };
like( $@, qr/ref of type/, 'non-Regexp ref stop_regex dies' );

eval { Algorithm::Classifier::NaiveBayes->new( 'lc_tokens' => {} ); };
like( $@, qr/ref of type/, 'ref lc_tokens dies' );

eval { Algorithm::Classifier::NaiveBayes->new( 'stop_regex' => qr/at|a/ ); };
is( $@, '', 'qr// Regexp stop_regex is accepted' );

eval { Algorithm::Classifier::NaiveBayes->new( 'token_splitter' => undef ); };
is( $@, '', 'explicit undef args are accepted' );

done_testing;
