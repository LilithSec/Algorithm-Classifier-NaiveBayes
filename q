[ham] free money click here
    fuck = -4.277
    ham = -3.060
    spam = -3.366
[ham] team meeting at the office tomorrow
    fuck = -5.663
    ham = -3.636
    spam = -3.839
[ham] win a cheap prize today
    fuck = -4.970
    ham = -3.348
    spam = -3.602
[ham] eat at joes
    fuck = -3.584
    ham = -2.773
    spam = -3.130
[ham] fuck off
    fuck = -2.890
    ham = -2.485
    spam = -2.893
[ham] derp off
    fuck = -2.890
    ham = -2.485
    spam = -2.893
[ham] pants
    fuck = -1.504
    ham = -0.811
    spam = -1.099
[ham] pants pants
    fuck = -2.890
    ham = -2.485
    spam = -2.893
[ham] time off
    fuck = -2.890
    ham = -2.485
    spam = -2.893
[ham] fuck
    fuck = -1.504
    ham = -0.811
    spam = -1.099
[ham] fuck fuck
    fuck = -2.890
    ham = -2.485
    spam = -2.893
$VAR1 = bless( {
                 'model' => {
                              'total_docs' => 9,
                              'tokens' => {
                                            ' ' => 1,
                                            '' => 1
                                          },
                              'lc_tokens' => 1,
                              'class_totals' => {
                                                  'fuck' => 2,
                                                  'spam' => 17,
                                                  'ham' => 18
                                                },
                              'class_counts' => {
                                                  'spam' => 3,
                                                  'fuck' => 2,
                                                  'ham' => 4
                                                },
                              'token_counts' => {
                                                  'fuck' => {
                                                              '' => 1,
                                                              ' ' => 1
                                                            },
                                                  'spam' => {
                                                              ' ' => 14,
                                                              '' => 3
                                                            },
                                                  'ham' => {
                                                             ' ' => 14,
                                                             '' => 4
                                                           }
                                                },
                              'token' => {}
                            }
               }, 'Algorithm::Classifier::NaiveBayes' );
