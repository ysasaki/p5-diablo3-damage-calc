#!perl

use v5.14;
use warnings;
use Pod::Usage;
use Getopt::Long;
use Diablo3::Damage::Calc;
use Diablo3::Damage::Weapon;

my $ret = GetOptions(
    \my %o,                     'min|mi=i@',
    'max|ma=i@',                'primary_stat|p=i',
    'critical_hit_chance|cc=f', 'critical_hit_damage|cd=i',
    'attack_speed|a=f@',        'buff|b=f',
    'help|h',
);

if ( $o{help} or !$ret ) {
    pod2usage(1);
}

for (qw(max min attack_speed)) {
    unless ( defined $o{$_}->[0] ) {
        warn "Mandatory parameter $_ is missing\n";
        pod2usage(1);
    }
}

for (qw(primary_stat)) {
    unless ( defined $o{$_} ) {
        warn "Mandatory parameter $_ is missing\n";
        pod2usage(1);
    }
}

$o{critical_hit_chance} //= 5;
$o{critical_hit_damage} //= 50;
$o{buff}                //= 0;

my $calc = Diablo3::Damage::Calc->new(
    main_weapon => Diablo3::Damage::Weapon->new(
        map { $_ => $o{$_}->[0] } qw/min max attack_speed/
    ),
    off_hand => Diablo3::Damage::Weapon->new(
        map { $_ => $o{$_}->[1] } qw/min max attack_speed/
    ),
    map { $_ => $o{$_} }
        qw/primary_stat critical_hit_chance critical_hit_damage buff/
);

my ( $base, $base_buffed ) = $calc->base_damage;
printf "Base Damage: %.2f(%.2f)\n", $base, $base_buffed;

my ( $critical_damage, $critical_damage_buffed ) = $calc->critical_damage;
printf "Critical Chance: %.2f\n",       $calc->critical_hit_chance;
printf "Critical Damage: %.2f(%.2f)\n", $critical_damage,
    $critical_damage_buffed;

my ( $avg, $avg_buffed ) = $calc->average_damage;
printf "Avg: %.2f(%.2f)\n", $avg, $avg_buffed;

my ( $aps, $main_aps, $off_aps ) = $calc->attack_per_second;
printf "APS: %.2f(%0.2f, %.2f)\n", $aps, $main_aps, $off_aps;
printf "DPS: %.2f(%.2f)\n", $aps * $avg, $aps * $avg_buffed;

=head1 SYNOPSIS

d3-damage.pl

    --min | -mi

    --max | -ma

    --attack_speed | -a

    --primary_stat | -p

    --critical_hit_chance | -cc
        default 5

    --critical_hit_damage | -cd
        default 50

    --buff | -b
        default 0

    --help | -h

=over 4

=item One Hand

    d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -mi 300 -ma 700 -a 1.35 

=item Dual Wielding

    d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35 

=back

=cut

__END__
http://gaming.stackexchange.com/questions/71589/calculating-dual-wield-character-dps
(
    (1 + passive skill boosts)
    (Weapon 1 average damage +
        ((minimum damage bonus + maximum damage bonus)/2))
    (Weapon Damage Multipliers)
    (Attack Spee)
    (1 + ( crit% * crit damage %))
    ( 1 + (main stat / 100))
    (average attack speed of both weapons / weapon 1 attack speed) +

    (1 + passive skill boosts)
    (Weapon 2 average damage +
        ((minimum damage bonus + maximum damage bonus)/2))
    (Weapon Damage Multipliers)
    (Attack Speed)
    (1 + ( crit% * crit damage %))
    ( 1 + (main stat / 100))
    (average attack speed of both weapons / weapon 2 attack speed)
) * 0.575

0.575 = Dual Wielding Bonus Attack Speed / 2
Dual Wielding Bonus Attack Speed = 1.15

