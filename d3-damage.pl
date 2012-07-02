#!/usr/bin/env perl

use strict;
use warnings;
use Pod::Usage;
use Getopt::Long;

my $ret = GetOptions(
    \my %o,
    'min|mi=i',
    'max|ma=i',
    'primary-stat|p=i',
    'critical-hit-chance|cc=f',
    'critical-hit-damage|cd=i',
    'attack-speed|a=f',
    'buff|b=f',
    'help|h',
);

if ( $o{help} or !$ret )  {
    pod2usage(1);
}

$o{buff} ||= 0;
my $buffed = (1+$o{buff}/100);

my $base = ($o{min}+$o{max}) / 2 * $o{'primary-stat'}/100;
my $buffed_base = $base * $buffed;
printf "Base Damage: %.2f(%.2f)\n", $base, $buffed_base;

my $critical_damage = $base*(1+$o{'critical-hit-damage'}/100);
printf "Critical Damage: %.2f(%.2f)\n", $critical_damage, $critical_damage * $buffed;
printf "Critical Chance: %.2f\n", $o{'critical-hit-chance'};

my $normal   = (1-$o{'critical-hit-chance'}/100)*$base;
my $critical = ($o{'critical-hit-chance'}/100)*$critical_damage;
my $avg = $normal + $critical;
printf "Avg: %.2f(%.2f)\n", $avg, $avg * $buffed;

printf "APS: %.2f\n", $o{'attack-speed'};
printf "DPS: %.2f(%.2f)\n", $o{'attack-speed'} * $avg, $o{'attack-speed'} * $avg * $buffed;

=head1 SYNOPSIS

d3-damage.pl

    --min | -mi
    --max | -ma
    --primary-stat | -p
    --critical-hit-chance | -cc
    --critical-hit-damage | -cd
    --attack-speed | -a
    --buff | -b
    --help | -h

e.g.

    perl d3-damage.pl -mi 300 -ma 700 -p 1100 -cc 12.5 -cd 97 -a 1.35 -b 15

=cut