#!perl
use 5.010;
use strict;
use warnings;
use Test2::V0;
use Tree::STR;

diag( "Testing Tree::STR $Tree::STR::VERSION, Perl $], $^X" );

{
    my @data;
    my $size = 1;
    my $s2 = $size / 2;
    for my $x (1 .. 5) {
        for my $y (1 .. 15) {
            # next if $y % 2;
            my ($x1, $y1, $x2, $y2) = ($x - $s2, $y - $s2, $x + $s2, $y + $s2);
            push @data, [ $x1, $y1, $x2, $y2, join ':', ($x1, $y1, $x2, $y2) ];
        }
    }

    my $tree = Tree::STR->new(\@data);
    my $qp_res = $tree->query_point(1, 1);
    is($qp_res, [ "0.5:0.5:1.5:1.5" ], 'query_point');

    my $qr_res_pt = $tree->query_partly_within_rect(1, 1, 1, 1);
    is($qr_res_pt, [ "0.5:0.5:1.5:1.5" ], 'query_partly_within_rect for a point');

    my $qr_res_box = $tree->query_partly_within_rect(1, 1, 3, 3);
    my $exp = [
        "0.5:0.5:1.5:1.5",
        "0.5:1.5:1.5:2.5",
        "0.5:2.5:1.5:3.5",
    ];
    is($qr_res_box, $exp, 'query_partly_within_rect for a box');

    my $q_completely_in_box
        = $tree->query_completely_within_rect(0.25, 0.25, 3.75, 3.75);
    is($q_completely_in_box, $exp, 'query_completely_within_rect for a box');
}

#  some more
{
    my $data = [ [ 1, 1, 2, 2, 'item 1' ], [ 10, 20, 100, 200, 'item 2' ] ];
    my $tree = Tree::STR->new($data);
    my $intersects_point = $tree->query_point(50, 50);
    is ($intersects_point, ['item 2'], 'intersects point');
    my $intersects_poly = $tree->query_partly_within_rect(20, 20, 200, 200);
    is ($intersects_poly, ['item 2'], 'intersects poly');
    my $intersects_poly2 = $tree->query_completely_within_rect(0, 0, 4, 4);
    is ($intersects_poly2, ['item 1'], 'intersects poly completely');
}

done_testing;
