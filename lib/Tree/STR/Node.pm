package Tree::STR::Node;
use strict;
use warnings;
use 5.010;

sub new {
    my ($class, %args) = @_;
    my $self = bless {
        bbox     => $args{bbox},
        children => $args{children},
        tip      => $args{tip},
    }, $class;

    return $self;
}

sub is_tip_node {
    my ($self) = @_;
    !!$self->{tip};
}

sub is_inner_node {
    my ($self) = @_;
    !!$self->{children};
}

sub bbox {
    my ($self) = @_;
    $self->{bbox};
}

sub query_point {
    my ($self, $x, $y) = @_;
    my $bbox = $self->bbox;

    return [] if $x < $bbox->[0] || $x > $bbox->[2] || $y < $bbox->[1] || $y > $bbox->[3];

    return [$self->{tip}] if $self->is_tip_node;

    my @collated;
    foreach my $child (@{ $self->{children} // [] }) {
        my $res = $child->query_point ($x, $y);
        say "$child " . join @$res;
        push @collated, @$res;
    }
    return \@collated;
}

1;