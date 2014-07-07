#!/usr/bin/perl
use strict;

sub lengths {
    my @ret;
    my @bounds = (@_,1);
    my $last = -1;
    for(0 .. $#bounds) {
        if($bounds[$_]) {
            push @ret, ($_-$last);
            $last = $_;
        }
    }
    return @ret;
}

open REF, "<:utf8", $ARGV[0] or die $!;
open TEST, "<:utf8", $ARGV[1] or die $!;
my ($ref, $test);
my ($totb, $corb, $refw, $testw, $corw,$tots,$cors);
while($ref = <REF> and $test = <TEST>) {
    chomp $ref; chomp $test;
    $tots++;
    $cors++ if ($ref eq $test);
    $ref =~ s/\/[^ ]*//g;
    $test =~ s/\/[^ ]*//g;
    my @rarr = split(//, $ref);
    my @tarr = split(//, $test);
    shift @rarr;
    shift @tarr;
    my (@rb,@tb);
    while(@rarr and @tarr) {
        my $rs = ($rarr[0] eq ' ');
        shift @rarr if $rs;
        push @rb, $rs;
        my $ts = ($tarr[0] eq ' ');
        shift @tarr if $ts;
        push @tb, $ts;
        shift @tarr;
        shift @rarr;
    }
    die "mismatched lines \n$ref\n$test\n" if(@rb != @tb);
    # total boundaries
    $totb += @rb;
    # correct boundaries
    for(0 .. $#rb) { $corb++ if ($rb[$_] == $tb[$_]); }
    # find word counts
    my @rlens = lengths(@rb);
    $refw += @rlens;
    my @tlens = lengths(@tb);
    $testw += @tlens;
    # print "$ref\n@rlens\n$test\n@tlens\n";
    # find word matches
    my ($rlast, $tlast);
    while(@rlens and @tlens) {
        if($rlast == $tlast) {
            $corw++ if($rlens[0] == $tlens[0]);
        }
        if($rlast <= $tlast) {
            $rlast += shift(@rlens);
        }
        if($tlast < $rlast) {
            $tlast += shift(@tlens);
        }
    }
}
print "Sent Accuracy: ".sprintf("%.2f", ($cors/$tots*100))."% ($cors/$tots)\n";
my $precw = $corw/$testw;
my $recw = $corw/$refw;
my $fmeasw = (2*$precw*$recw)/($precw+$recw);
print "Word Prec: ".sprintf("%.2f", ($precw*100))."% ($corw/$testw)\n";
print "Word Rec: ".sprintf("%.2f", ($recw*100))."% ($corw/$refw)\n";
print "F-meas: ".sprintf("%.2f", ($fmeasw*100))."%\n";
print "Bound Accuracy: ".sprintf("%.2f", ($corb/$totb*100))."% ($corb/$totb)\n";
