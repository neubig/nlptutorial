#!/usr/bin/perl

# This is a script to grade word error rates according to edit distance

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

use utf8;
use strict;
use List::Util qw(max min);
use Cwd qw(cwd);

my $PRINT_INLINE = 1;

sub width {
    $_ = shift;
    my $ret = 0;
    for(split(//)) {
        $ret += ((/\p{InKatakana}/ or /\p{InHiragana}/ or /\p{InCJKSymbolsAndPunctuation}/ or /\p{InKatakanaPhoneticExtensions}/ or /\p{InCJKUnifiedIdeographs}/)?2:1);
    }
    return $ret;
}

sub pad {
    my ($s, $l) = @_;
    return $s . (' ' x ($l-width($s)));
}

# return a minimum edit distance path with the following notation, plus cost
#  d=delete i=insert s=substitute e=equal
sub levenshtein {
    my ($s, $t) = @_;
    my (@sc, $m, @tc, $n, %d, %str, $i, $j, $id, $cost, $type, $aid, $bid, $cid, $c);
    @sc = split(/ +/, $s);
    $m = @sc;
    @tc = split(/ +/, $t);
    $n = @tc;
    # initialize
    foreach $i (0 .. $m) { $id = pack('S2', $i, 0); $d{$id} = $i; $str{$id} = 'd'x$i; }
    foreach $j (1 .. $n) { $id = pack('S2', 0, $j); $d{$id} = $j; $str{$id} = 'i'x$j; }
    
    foreach $i (1 .. $m) {
        foreach $j (1 .. $n) {
            if($sc[$i-1] eq $tc[$j-1]) {
                $cost = 0; $type = 'e'; # equal
            } else {
                $cost = 1.1; $type = 's'; # substitution
            }

            $aid = pack('S2', $i-1, $j); $a = $d{$aid} + 1; # deletion
            $bid = pack('S2', $i, $j-1); $b = $d{$bid} + 1; # insertion
            $cid = pack('S2', $i-1, $j-1); $c = $d{$cid} + $cost; # insertion
            
            $id = pack('S2', $i, $j);
            
            # we want matches to come at the end, so do deletions/insertions first
            if($a <= $b and $a <= $c) {
                $d{$id} = $a;
                $type = 'd';
                $str{$id} = $str{$aid}.'d';
            }
            elsif($b <= $c) {
                $d{$id} = $b;
                $type = 'i';
                $str{$id} = $str{$bid}.'i';
            }
            else {
                $d{$id} = $c;
                $str{$id} = $str{$cid}.$type;
            }

            delete $d{$cid};
            delete $str{$cid};
            # print "".$sc[$i-1]." ".$tc[$j-1]." $i $j $a $b $c $d[$id] $type\n"
        }
    }

    $id = pack('S2', $m, $n);
    return ($str{$id}, $d{$id}); 
}

open REF, "<:utf8", $ARGV[0];
open TEST, "<:utf8", $ARGV[1];

my ($reflen, $testlen);
my %scores = ();
my($ref, $test, $sent, $sentacc);
while($ref = <REF> and $test = <TEST>) {
    chomp $ref;
    chomp $test;
    $ref =~ s/ //g; $ref =~ s/(.)/$1 /g; $ref =~ s/ $//g;
    $test =~ s/ //g; $test =~ s/(.)/$1 /g; $test =~ s/ $//g;

    # get the arrays
    my @ra = split(/ +/, $ref);
    $reflen += @ra;
    my @ta = split(/ +/, $test);
    $testlen += @ta;

    # do levenshtein distance if the scores aren't equal
    my ($hist, $score);
    if ($ref eq $test) {
        $sentacc++;
        for (@ra) { $hist .= 'e'; }
        $score = 0;
    } else {
        ($hist, $score) = levenshtein($ref, $test);
    }
    $sent++;

    my @ha = split(//, $hist);
    my ($rd, $td, $hd, $h, $r, $t, $l);
    if(not $PRINT_INLINE) {
        while(@ha) {
            $h = shift(@ha);
            $scores{$h}++;
            if($h eq 'e' or $h eq 's') {
                $r = shift(@ra);
                $t = shift(@ta);
            } elsif ($h eq 'i') {
                $r = '';
                $t = shift(@ta);
            } elsif ($h eq 'd') {
                $r = shift(@ra);
                $t = '';
            } else { die "bad history value $h"; }
            # find the length
            $l = max(width($r), width($t)) + 1;
            $rd .= pad($r, $l);
            $td .= pad($t, $l);
            $hd .= pad($h, $l);
        }
        print "$rd\n$td\n$hd\n\n";
    } else {
        my (@er, @et, @dr, @dt);
        while(@ha) {
            $h = shift(@ha);
            $scores{$h}++;
            if($h eq 'e') {
                if(@dr or @dt) {
                    print "X\t@dr\t@dt\n"; @dr = (); @dt = ();
                }
                push @er, shift(@ra);
                push @et, shift(@ta);
            } else {
                if(@er or @et) {
                    die "@er != @et" if("@er" ne "@et");
                    print "O\t@er\t@et\n"; @er = (); @et = ();
                }
                push @dr, shift(@ra) if $h ne 'i';
                push @dt, shift(@ta) if $h ne 'd';
            }
        }
        if(@dr or @dt) { print "X\t@dr\t@dt\n\n"; }
        elsif(@er or @et) { print "O\t@er\t@et\n\n"; }
    }
    die "non-empty ra=@ra or ta=@ta\n" if(@ra or @ta);
}

my $total = 0;
for (values %scores) { $total += $_; }
foreach my $k (keys %scores) {
    print "$k: $scores{$k} (".$scores{$k}/$total*100 . "%)\n";
}
my $wer = ($scores{'s'}+$scores{'i'}+$scores{'d'})/$reflen*100;
my $prec = $scores{'e'}/$testlen*100;
my $rec = $scores{'e'}/$reflen*100;
my $fmeas = (2*$prec*$rec)/($prec+$rec);
$sentacc = $sentacc/$sent*100;
printf ("WER: %.2f%%\nPrec: %.2f%%\nRec: %.2f%%\nF-meas: %.2f%%\nSent: %.2f%%\n", $wer, $prec, $rec, $fmeas, $sentacc);

