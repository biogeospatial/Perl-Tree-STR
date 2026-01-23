#!perl
use 5.010;
use strict;
use warnings;
use Test2::V0;
use Tree::STR;

diag( "Testing Tree::STR $Tree::STR::VERSION, Perl $], $^X" );


my @data;
my $size = 1;
my $s2 = $size / 2;
for my $x (1..5) {
    for my $y (1..15) {
        # next if $y % 2;
        my ($x1, $y1, $x2, $y2) = ($x-$s2, $y-$s2, $x+$s2, $y+$s2);
        push @data, [$x1, $y1, $x2, $y2, join ':', ($x1, $y1, $x2, $y2)];
    }
}

my $tree = Tree::STR->new (\@data);
my $qp_res = $tree->query_point (1,1);
is ($qp_res, ["0.5:0.5:1.5:1.5"], 'query_point');

my $qr_res_pt = $tree->query_partly_within_rect (1, 1, 1, 1);
is ($qr_res_pt, ["0.5:0.5:1.5:1.5"], 'query_partly_within_rect for a point');

my $qr_res_box = $tree->query_partly_within_rect (1, 1, 3, 3);
my $exp = [
    "0.5:0.5:1.5:1.5",
    "0.5:1.5:1.5:2.5",
    "0.5:2.5:1.5:3.5",
];
is ($qr_res_box, $exp, 'query_partly_within_rect for a box');

done_testing;
