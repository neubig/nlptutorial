#!/usr/bin/perl

use strict;
use utf8;
use Getopt::Long;
use List::Util qw(sum min max shuffle);
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

if(@ARGV != 2) {
    print STDERR "Usage: $0 REFERENCE TEST\n";
    exit 1;
}

open FILE0, "<:utf8", $ARGV[0] or die "Couldn't open $ARGV[0]\n";
open FILE1, "<:utf8", $ARGV[1] or die "Couldn't open $ARGV[1]\n";

my (%mistakes, $total, $correct);
my ($s0, $s1);
while(($s0 = <FILE0>) and ($s1 = <FILE1>)) {
    chomp $s0; chomp $s1;
    my @a0 = split(/ /, $s0);
    my @a1 = split(/ /, $s1);
    if(@a0 != @a1) {
        print STDERR "Line lengths don't match:\n@a0\n@a1\n";
        exit 1;
    }
    foreach my $i (0 .. $#a0) {
        $a0[$i] =~ s/\S*_//g;
        $a1[$i] =~ s/\S*_//g;
        $total++;
        if ($a0[$i] eq $a1[$i]) {
            $correct++;
        } else {
            $mistakes{"$a0[$i] --> $a1[$i]"}++;
        }
    }
}

printf "Accuracy: %.02f%% (%d/%d)\n\nMost common mistakes:\n", $correct/$total*100, $correct, $total;

my $mist_count;
for(sort { $mistakes{$b} <=> $mistakes{$a} } keys %mistakes) {
    last if $mist_count++ >= 10;
    print "$_\t$mistakes{$_}\n";
}

