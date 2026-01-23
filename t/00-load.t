#!perl
use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Tree::STR' ) || print "Bail out!\n";
}

diag( "Testing Tree::STR $Tree::STR::VERSION, Perl $], $^X" );


my @data;
for my $x (1..5) {
    for my $y (1..15) {
        next if $y % 2;
        push @data, [$x-1, $y-1, $x+1, $y+1, ["$x:$y"]]
    }
}

my $tree = Tree::STR->new (\@data);
