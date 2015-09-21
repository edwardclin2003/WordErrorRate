# WordErrorRate
Perl script that calculates Word Error Rate from a hypothesis and reference text file. The definition of WER can be found here: https://en.wikipedia.org/wiki/Word_error_rate

This is old code in case anyone wants a perl implementation of the WER calculator.
The text is case insensitive.  
Usage: perl WER.pl <hypothesis file> <reference file>

Example:

perl WER.pl hyp.txt ref.txt

Explanation:
Hyp. sentence:      "How tall are you"
Reference sentence: "How are you"
'tall' is the inserted error word so the # of errors is 1 and the WER is 33.3%.


