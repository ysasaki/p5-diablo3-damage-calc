package Diablo3::Damage::Calc;

use v5.14;
use warnings;
use Class::Accessor::Lite (
    new => 1,
    ro  => [
        qw/
            main_weapon off_hand primary_stat
            critical_hit_chance critical_hit_damage buff
            /
    ],
);

our $VERSION = '0.02';

sub buffed {
    my $self = shift;
    my $buff = ( 1 + $self->buff / 100 );
    return $buff;
}

sub base_damage {
    my $self = shift;

    unless ( $self->{_base} ) {
        my $avg = $self->main_weapon->avg;
        if ( $self->off_hand->is_equipped ) {
            $avg += $self->off_hand->avg;
            $avg /= 2;
        }
        $self->{_base} = $avg * $self->primary_stat / 100;
    }
    my $base = $self->{_base};
    return $base, $base * $self->buffed;

}

sub critical_damage {
    my $self = shift;

    my ( $base, $base_buffed ) = $self->base_damage;
    my $critical_damage = $base * $self->critical_hit_damage_ratio;

    return $critical_damage, $critical_damage * $self->buffed;
}

sub critical_hit_damage_ratio {
    my $self  = shift;
    my $ratio = 1 + $self->critical_hit_damage / 100;
    return $ratio;
}

sub average_damage {
    my $self = shift;

    my ($base)     = $self->base_damage;
    my ($critical) = $self->critical_damage;
    my $chance     = $self->critical_hit_chance;
    my $avg = ( 1 - $chance / 100 ) * $base + ( $chance / 100 ) * $critical;

    return $avg, $avg * $self->buffed;
}

sub attack_per_second {
    my $self = shift;

    my $is_dual = $self->off_hand->is_equipped ? 1 : 0;

    my $main
        = $is_dual
        ? $self->main_weapon->attack_speed * 1.15
        : $self->main_weapon->attack_speed;

    my $off
        = $is_dual
        ? $self->off_hand->attack_speed * 1.15
        : 0;

    my $aps
        = $is_dual
        ? ( $main + $off ) / 2
        : $main;

    return $aps, $main, $off;
}

=head1 NAME

Diablo3::Damage::Cacl - Perl extention for calculating damages of Diablo3

=head1 SYNOPSIS

See C<d3-damage.pl --help>

=head1 AUTHOR

Yoshihiro Sasaki E<lt>ysasaki at cpan.org<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 COPYRIGHT

Copyright 2012 IDAC CO.,LTD. All rights reserved.

=cut

1;
