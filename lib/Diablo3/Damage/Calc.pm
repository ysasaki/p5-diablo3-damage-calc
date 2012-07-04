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
use Carp ();

our $VERSION = '0.10';

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

sub as_string {
    my $self = shift;

    my @line;
    my ( $base, $base_buffed ) = $self->base_damage;
    push @line, sprintf "Base Damage    : %8.2f (%8.2f)", $base, $base_buffed;

    my ( $critical_damage, $critical_damage_buffed ) = $self->critical_damage;
    push @line, sprintf "Critical Chance: %8.2f", $self->critical_hit_chance;
    push @line, sprintf "Critical Damage: %8.2f (%8.2f)", $critical_damage,
        $critical_damage_buffed;

    my ( $avg, $avg_buffed ) = $self->average_damage;
    push @line, sprintf "Avg            : %8.2f (%8.2f)", $avg, $avg_buffed;

    my ( $aps, $main_aps, $off_aps ) = $self->attack_per_second;
    push @line, sprintf "APS            : %8.2f (%3.2f, %3.2f)", $aps, $main_aps,
        $off_aps;
    push @line, sprintf "DPS            : %8.2f (%8.2f)", $aps * $avg,
        $aps * $avg_buffed;

    return join "\n", @line;
}

sub as_compared_string {
    my $self      = shift;
    my $base_calc = shift;
    unless ($base_calc) {
        Carp::carp "as_compared_string is required base Calc object.";
        return $self->as_string;
    }

    my @line;

    # Base
    my ( $base, $base_buffed ) = $self->base_damage;
    my ($base_c) = $base_calc->base_damage;
    push @line, sprintf "Base Damage    : %8.2f (%8.2f)   %6.2f%%",
        $base, $base_buffed, _per( $base, $base_c );

    # Critical
    my ( $critical_damage, $critical_damage_buffed ) = $self->critical_damage;
    my ($critical_damage_c) = $base_calc->critical_damage;
    push @line, sprintf "Critical Chance: %8.2f              %6.2f%%",
        $self->critical_hit_chance,
        _per( $self->critical_hit_chance, $base_calc->critical_hit_chance );

    push @line, sprintf "Critical Damage: %8.2f (%8.2f)   %6.2f%%",
        $critical_damage,
        $critical_damage_buffed, _per( $critical_damage, $critical_damage_c );

    # AVG
    my ( $avg, $avg_buffed ) = $self->average_damage;
    my ($avg_c) = $base_calc->average_damage;
    push @line, sprintf "Avg            : %8.2f (%8.2f)   %6.2f%%", $avg,
        $avg_buffed, _per( $avg, $avg_c );

    # APS, DPS
    my ( $aps,   $main_aps,   $off_aps )   = $self->attack_per_second;
    my ( $aps_c, $main_aps_c, $off_aps_c ) = $base_calc->attack_per_second;
    push @line,
        sprintf
        "APS            : %8.2f (%3.2f, %3.2f) %6.2f%% (%6.2f%%, %6.2f%%)",
        $aps, $main_aps, $off_aps,
        _per( $aps, $aps_c ), _per( $main_aps, $main_aps_c ),
        _per( $off_aps, $off_aps_c );

    push @line, sprintf "DPS            : %8.2f (%8.2f)   %6.2f%%", $aps * $avg,
        $aps * $avg_buffed, _per( $aps * $avg, $aps_c * $avg_c );

    return join "\n", @line;
}

sub _per { 100 * (($_[0]/$_[1]) - 1)}

=head1 NAME

Diablo3::Damage::Cacl - Perl extention for calculating damages of Diablo3

=head1 SYNOPSIS

See C<d3-damage.pl --help> or C<d3-damage-compare.pl --help>

=head1 AUTHOR

Yoshihiro Sasaki E<lt>ysasaki at cpan.org<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 COPYRIGHT

Copyright 2012 IDAC CO.,LTD. All rights reserved.

=cut

1;
