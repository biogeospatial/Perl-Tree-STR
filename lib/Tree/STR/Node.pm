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

1;