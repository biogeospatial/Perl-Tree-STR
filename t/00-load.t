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


done_testing;
