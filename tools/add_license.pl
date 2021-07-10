#! /usr/bin/perl -w

# Cengiz Gunay <cgunay@emory.edu> 2007/08/02

use strict;

if ($#ARGV < 0) {
  printf "Usage: $0 filename\nAdds license text into given file.\n\n";
  exit -1;
}

my $filename = $ARGV[0];
my $file = `cat $filename` || die "Cannot read method file $filename: $!";

$_= $file;

#print $file;
#if (/.*emory.*/) { print "aaaa\n"; }
#if (m/(^%.*^\s*$)/sm) { print "$1\n"; };

my $license_text = << "EOF";
% Copyright (c) 2007 Cengiz Gunay <cengique\@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.
EOF

die "Copyright statement exists in $filename." if m/copyright/i;

# insert right after the comments section in the file
die "Failed to insert license into $filename." unless s/(^%.*[^a]^(?!%))/$1\n$license_text/m;

# clobber and overwrite file with new info
open OUTPUT, ">$filename" || die "Cannot write $filename: $!";
print OUTPUT $_;
close OUTPUT;

