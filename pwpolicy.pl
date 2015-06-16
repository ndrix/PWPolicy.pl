#!/usr/bin/perl
#
# Takes an input and an output file, and follows a password policy when
# outputting it. This makes it easier to filter out 'weak' passwords in 
# a large textfile when you know that there's some sort of policy being
# followed (complexity, minimum length, ...).  
# Lottsa room for improvement.  Feel free to fork and alter it.  
# -mh
#
# Comments to me@michaelhendrickx.com or @ndrix

use strict;
use Getopt::Std;
my %opts=();
my $inFile;
my $outFile;
my $minLen = 8;
my $maxLen = 16;

sub showHelp{
  print "PWPolicy.pl by \@ndrix\n\n";
  print "options:\n";
  print " -i <file>   input file (-- for stdin)\n";
  print " -o <file>   output file (-- for stdout)\n";
  print " -p [udsl]   policy (uppercase, digits, special char, lowercase)\n";
  print " -l [range]  length of passwords ex: 8-10\n";
  print " -a          only keep ASCII characters\n";
  print " -v          verbose\n\n";
  exit(1);
}

# get the arguments
getopts("vi:o:p:l:ia", \%opts);
showHelp() unless (defined $opts{i} and defined $opts{o});

if(defined $opts{l}){
  ($minLen, $maxLen) = split(/[-:]/, $opts{l});
}

# verbose
if (defined $opts{v}){
  print STDOUT "-[ words between ".$minLen." and ".$maxLen." chars\n";
  if(defined $opts{p}){
    my %a = ('u','uppercase','l','lowercase','d','digit','s','special');
    foreach (split(//, $opts{p})){
      print STDOUT "-[ include ".$a{$_}." chars\n"
    }
  }
}

# open the input
if($opts{i} eq '--'){
  $inFile = *STDIN;
}
else {
  unless(open($inFile, "<", $opts{i})){
    print("Error: could not open ".$opts{i}." for reading\n");
    exit(1);
  }
}

#open the output
if($opts{o} eq '--'){
  $outFile = *STDOUT;
}
else {
  unless(open($outFile, ">", $opts{o})){
    print("Error: could not open ".$opts{o}." for writing\n");
    exit(1);
  }
}

# got it all, hammer time.
foreach my $line ( <$inFile> ){
  chomp($line);
  if(defined $opts{a}){ $line =~ s/^(?:(?![ -~ ]).)+$//; }
  if(defined $opts{p}){
    next if($opts{p} =~ /l/ and $line !~ /[[:lower:]]/);
    next if($opts{p} =~ /u/ and $line !~ /[[:upper:]]/);
    next if($opts{p} =~ /d/ and $line !~ /[[:digit:]]/);
    next if($opts{p} =~ /s/ and $line !~ /[[:punct:]]/);
  }
  next if(length($line) < $minLen or length($line) > $maxLen);
  $outFile->print($line."\n");
}
