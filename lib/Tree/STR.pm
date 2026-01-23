package Tree::STR;

use 5.010;
use strict;
use warnings;

use Tree::STR::Node;

use POSIX qw /ceil/;
use List::Util qw /min max/;
use Ref::Util qw/is_blessed_ref is_arrayref/;


=head1 NAME

Tree::STR - A Sort-Tile-Recursive tree index

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use Tree::STR;

    my $foo = Tree::STR->new();
    ...

=head1 EXPORT

None.

=head1 SUBROUTINES/METHODS

=head new

=cut

sub new {
    my ($class, $data, $n) = @_;
    my $self = bless { nrects => $n // 3}, $class;
    $self->{root} = $self->_load_data ($data);
    return $self;
}

sub bbox {
    my ($self) = @_;
    return if !$self->{root};
    $self->{root}->bbox;
}

sub _load_data {
    my ($self, $data) = @_;
    #  we need to work on the bbox centres
    my @bboxed = map {is_blessed_ref $_ && $_->can('bbox') ? [$_->bbox, $_] : $_} @$data;
    my @centred = map {[($_->[0] + $_->[2] / 2), ($_->[1] + $_->[3] / 2), $_]} @bboxed;
    return $self->_load_data_inner(\@centred);
}

sub _load_data_inner {
    my ($self, $data, $sort_axis) = @_;

    $sort_axis //= 0;
    my @sorted = sort {$a->[$sort_axis] <=> $b->[$sort_axis]} @$data;

    my $nrects = $self->{nrects};
    my $nitems = @$data;
    my $n_per_box = ceil (sqrt ($nitems / $nrects));
    my @ranges = map
        {my $base = $n_per_box * $_; [$base,$base+$n_per_box-1]}
        (0..$nrects-1);

    #  switch axis for inner calls
    $sort_axis = $sort_axis ? 0 : 1;

    my @nodes;
    for my $range (@ranges) {
        my @recs = @sorted[$range->[0]..min($#sorted, $range->[1])];
        my @bbox = $self->_get_bbox_from_centred_recs(\@recs);
        if (@recs > 1) {
            push @nodes, Tree::STR::Node->new (
                bbox     => \@bbox,
                children => $self->_load_data_inner(\@recs, $sort_axis),
            );
        }
        else {
            push @nodes, Tree::STR::Node->new (
                bbox => \@bbox,
                tip  => \@recs
            );
        }
    }
    return \@nodes;
}

sub _get_bbox_from_centred_recs {
    my ($self, $recs) = @_;
    state $bbox_idx = 2;
    my ($x1, $y1, $x2, $y2) = @{$recs->[0][$bbox_idx]}[0 .. 3];
    return ($x1, $y1, $x2, $y2)
        if @$recs == 1;
    foreach my $rec (@$recs) {
        my $bbox = $rec->[$bbox_idx];
        $x1 = min($x1, $bbox->[0]);
        $y1 = min($y1, $bbox->[1]);
        $x2 = max($x1, $bbox->[2]);
        $y2 = max($x1, $bbox->[3]);
    }
    return $x1, $y1, $x2, $y2;
}

=head2 function1

=cut

sub query_point {
}

=head2 function2

=cut

sub query_partly_within_rect {
}

=head1 AUTHOR

Shawn Laffan <shawnlaffan@gmail.com>

=head1 BUGS

L<https://github.com/biogeospatial/Tree-STR/issues>

=back


=head1 SEE ALSO

Tree::R

Geo::Geos::Index::STRtree


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2026 by Shawn Laffan <shawnlaffan@gmail.com>.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Tree::STR
