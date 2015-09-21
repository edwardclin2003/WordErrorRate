####################################################
#
#     Word Error Rate calculator using dynamic programming
#     takes in reference file of correct speech
#     and hypothesis file of hypothesized speech
#     calculates the word error rate
#     Three types of errors
#     1)Insertion 
#       ex. Reference sentence: "How are you"
#	    Hyp. sentence:      "How tall are you"
#	    'tall' is the inserted error word
#     2) Substitution
#       ex. Reference sentence: "How are you"
#	    Hyp. sentence:      "How are they"
#	    'they' is the substituted word for 'you'
#     3) Deletion
#       ex. Reference sentence: "How are you"
#           Hyp. sentence:      "Are you"
#           'How' is deleted
#
#     			by Edward Lin
#    			  4/13/2003
#
###################################################

#!usr/bin/perl

$reffile=$ARGV[1];
$hypfile=$ARGV[0];
$bestscore=0;
$refptr=0;
$hypptr=0;
@dperror;
@dphyp;
@dpref;

#store lines to array ref
open(REFHAND, $reffile);
@ref=<REFHAND>;
close(REFHAND);

#store lines to array hyp
open(HYPHAND, $hypfile);
@hyp=<HYPHAND>;
close(HYPHAND);

#store words to refarray
push(@refarray, split(/\s/, $ref[0]));
print("ref: @refarray\n");
#store words to hyparray
push(@harray, split(/\s/, $hyp[0]));

foreach $hypelement (@harray) {
  if ($hypelement !~ /\</)
  {
    ($hypelement, $wordnum)=split(/\(/, $hypelement, 2);
    push(@hyparray, $hypelement);
  }
}
print("hyp: @hyparray\n");

#size of reference and hypothesis array
$numrefelements=scalar @refarray;
$numhypelements=scalar @hyparray;

$maxw=$numhypelements+1;
$maxr=$numrefelements+1;

print "number of reference words=$numrefelements number of hypothesis words=$numhypelements\n";

#initialization
$dperror[0]=$dphyp[0]=$dpref[0]=0;
for ($columncount=1; $columncount<=$numrefelements; $columncount++) {
  $dperror[$columncount*$maxw]=$columncount;
  $dphyp[$columncount*$maxw]=0;
  $dpref[$columncount*$maxw]=$columncount-1;
}
for ($rowcount=1; $rowcount<=$numhypelements; $rowcount++) {
  $dperror[$rowcount]=$rowcount;
  $dphyp[$rowcount]=$rowcount-1;
  $dpref[$rowcount]=0;
}

#calculate minimum error
for ($columncount=1; $columncount<=$numrefelements; $columncount++) {
  for ($rowcount=1; $rowcount<=$numhypelements; $rowcount++) {
    $wordsnotequal=($hyparray[$rowcount-1] eq $refarray[$columncount-1])?0:1; 
    $substitutionerror=$wordsnotequal+$dperror[($columncount-1)*$maxw+$rowcount-1];
    $deleteerror=1+$dperror[($columncount-1)*$maxw+$rowcount];
    $inserterror=1+$dperror[$columncount*$maxw+$rowcount-1];

    if (($substitutionerror <= $deleteerror)&&($substitutionerror <= $inserterror)) {
      $dpref[$columncount*$maxw+$rowcount]=$columncount-1;
      $dphyp[$columncount*$maxw+$rowcount]=$rowcount-1;
      $dperror[$columncount*$maxw+$rowcount]=$substitutionerror;
    }
    elsif ($deleteerror<=$inserterror) {
      $dpref[$columncount*$maxw+$rowcount]=$columncount-1;
      $dphyp[$columncount*$maxw+$rowcount]=$rowcount;
      $dperror[$columncount*$maxw+$rowcount]=$deleteerror;
    }         
    else {
      $dpref[$columncount*$maxw+$rowcount]=$columncount;
      $dphyp[$columncount*$maxw+$rowcount]=$rowcount-1;
      $dperror[$columncount*$maxw+$rowcount]=$inserterror;
    }
  }
}

$error=$dperror[$numrefelements*$maxw+$numhypelements];
print "error=$error\n";
$worderrorrate=100*($error/$numrefelements);
print "Word Error Rate=$worderrorrate%\n";

