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
    'attack_speed|a=f@',        'increase_attack_speed|ias=f',
    'buff|b=f',                 'help|h',
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

$o{critical_hit_chance}   //= 5;
$o{critical_hit_damage}   //= 50;
$o{increase_attack_speed} //= 0;
$o{buff}                  //= 0;

my $calc = Diablo3::Damage::Calc->new(
    main_weapon => Diablo3::Damage::Weapon->new(
        map { $_ => $o{$_}->[0] } qw/min max attack_speed/
    ),
    off_hand => Diablo3::Damage::Weapon->new(
        map { $_ => $o{$_}->[1] } qw/min max attack_speed/
    ),
    map { $_ => $o{$_} }
        qw/primary_stat critical_hit_chance critical_hit_damage
        increase_attack_speed buff/
);

print $calc->as_string, "\n";

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

    --increase_attack_speed | -ias
        sum of percentage of non-weapon gears. default 0%.

    --buff | -b
        default 0

    --help | -h

=over 4

=item One Hand

    d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -ias 7.5 -mi 300 -ma 700 -a 1.35 

=item Dual Wielding

    d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 -ab 7.5 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35 

=back

=cut
