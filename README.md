# Algorithm-Classifier-NaiveBayes

A multinomial naive Bayes text classifier for Perl with Laplace smoothing.

Strings are broken into tokens and each class is scored using the log of
its prior probability, based on how often the class was trained, plus the
sum of the log probabilities of each token appearing in that class. Token
probabilities use add-one, Laplace, smoothing so tokens never seen for a
class do not zero out the whole score.

Features...

- Classes are not predefined. Training a new class name brings it into
  existence and untraining everything for it removes it.
- Configurable tokenization. Token splitting regex, lowercasing, and an
  optional stop word regex.
- Models can be untrained as well as trained, so mistakes can be corrected
  without retraining from scratch.
- Models can be saved to and loaded from JSON, either as a string or a
  file. File writes are atomic.

## Usage

```perl
use Algorithm::Classifier::NaiveBayes;

my $nb = Algorithm::Classifier::NaiveBayes->new;

# train it with examples of each class
$nb->train( 'spam', 'buy cheap pills now' );
$nb->train( 'spam', 'cheap watches for sale' );
$nb->train( 'ham',  'meeting at noon tomorrow' );
$nb->train( 'ham',  'lunch with the team' );

# classify some new text
my $class = $nb->classify('cheap pills for sale');
# $class is now 'spam'

# or get the score for every class as well
my ( $best, $scores ) = $nb->classify('cheap pills for sale');

# save the model for later and load it again
$nb->save('model.json');

my $loaded = Algorithm::Classifier::NaiveBayes->new;
$loaded->load('model.json');
```

For full documentation see the POD for the module. Runnable examples,
including small command line training and classification scripts, can
be found under [examples/](examples/).

A command line tool, `nb_tool`, is also included for working with
saved models without writing any code.

```shell
nb_tool train -m model.json -c spam buy cheap pills now
nb_tool train -m model.json -c ham meeting at noon tomorrow

nb_tool classify -m model.json -p cheap pills
nb_tool explain -m model.json you have won a free cruise

nb_tool info -m model.json
nb_tool tokens -m model.json spam
nb_tool prune -m model.json 2
nb_tool untrain -m model.json -c spam buy cheap pills now
```

See `nb_tool commands` and `nb_tool help <command>` for the details.

## Installation

The non-core modules below are required.

- File::Slurp

### FreeBSD

```shell
pkg install perl5 p5-File-Slurp p5-App-cpanminus
cpanm Algorithm::Classifier::NaiveBayes
```

### Debian

```shell
apt-get install perl libfile-slurp-perl cpanminus
cpanm Algorithm::Classifier::NaiveBayes
```

### Source

To install this module from this repo, run the following commands.

```shell
perl Makefile.PL
make
make test
make install
```

## Support and Documentation

After installing, you can find documentation for this module with the
perldoc command.

```shell
perldoc Algorithm::Classifier::NaiveBayes
```

You can also look for information at:

- RT, CPAN's request tracker (report bugs here)
  https://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-Classifier-NaiveBayes

- Search CPAN
  https://metacpan.org/release/Algorithm-Classifier-NaiveBayes

## License and Copyright

This software is Copyright (c) 2026 by Zane C. Bowers-Hadley.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999
