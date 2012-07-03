package Diablo3::Damage::Weapon;

use v5.14;
use warnings;
use Class::Accessor::Lite (
    new => 1,
    ro  => [qw/min max attack_speed/],
);

sub avg {
    my $self = shift;
    ( $self->min + $self->max ) / 2;
}

sub is_equipped {
    my $self = shift;
    defined $self->min && defined $self->max && defined $self->attack_speed;
}

1;
