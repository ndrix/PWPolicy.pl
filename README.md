# PWPolicy.pl
This is a simple perl script that will take a password list and filter out passwords based on a certain policy (complexity, length, ...).  This makes it easier that when you want to do a bruteforce with a big password list, it won't try the weak passwords (too short, only lowercase ....) which you know won't work anyway.

## Usage
It's very straight forward, you basically need 4 things:
- input file (can be STDIN)
- output file (can be STDOUT)
- length of passwords (optional, as a range)
- complexity policy (optional)

For example:

  $ cat pwlist.txt | ./pwpolicy.pl -i -- -o 8-char-digits.txt -l 8-8 -p d

Will get all the passwords from STDIN, and only write away the ones that are exactly 8 chars (-l 8-8), and have at least a digit (-p d) in them.

  $ ./pwpolicy.pl -i rockyou.txt -o -- -l 8-10 -p ud 

Will take all passwords from rockyou.txt, and only display the ones between 8 and ten characters (both inclusive) which have at least one uppercase character, and one digit in them.  The -o parameter tells us that the output is pushed to STDOUT.

More information about the different options is written below.

### Options
Although quickly touched upon above, here are the options explained in detail:
- *-i <file>*: An input file which the script will read from.  Use a double dash ("--") to specify STDIN.  When specifying STDIN, you can pipe the output of another program to this script.
- *-o <file>*: An output file where all the filtered passwords are written to.  When specifing "--", this is written to STDOUT, so it can be piped to another command.
- *-l <minlen-maxlen>*: This specifies the length of the passwords to filter, both inclusive.  The output will only contain words that are not shorter than <minlen> and not longer than <maxlen>.
- *-p [slud]*: Password policy, whereby the letters stand for the following: *s*pecial characters, *l*owercase, *u*ppercase, *d*igits.  When specified, the script will only output a word that has at least one of these.
- *-a*: Only display passwords with ASCII compatible characters.
- *-v*: verbose output.

## Questions / Comments
This script was quickly written, so there's always room for improvement.  Feel free to fork it, or contact me at @ndrix.
