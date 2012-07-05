#!perl

use v5.14;
use warnings;
use Pod::Usage;
use Getopt::Long;
use Diablo3::Damage::Calc;
use Diablo3::Damage::Weapon;

my $ret = GetOptions( \my %o, 'file|f=s', 'help|h', );

if ( $o{help} or !$ret ) {
    pod2usage(1);
}

for (qw(file)) {
    unless ( defined $o{$_} ) {
        warn "Mandatory parameter $_ is missing.\n";
        pod2usage(1);
    }
}

open my $fh, '<', $o{file} or die "Cannot open $o{file}: $!";
my @lines = <$fh>;
close $fh;

if ( @lines < 2 ) {
    warn "Two ore more settings are required in config file.\n";
    pod2usage(1);
}

my ( $base, @others ) = create_calc_from_config(@lines);

line();
print $base->{_args};
line();
print $base->as_string, "\n\n";
for (@others) {
    line();
    print $_->{_args};
    line();
    print $_->as_compared_string($base), "\n\n";
}

sub line {
    print "=" x 78, "\n";
}

sub create_calc_from_config {
    my @lines = @_;

    my @calc;
    my $i = 1;
    for my $args (@lines) {
        local @ARGV = split /\s+/, $args;
        my $ret = GetOptions(
            \my %o,                     'min|mi=i@',
            'max|ma=i@',                'primary_stat|p=i',
            'critical_hit_chance|cc=f', 'critical_hit_damage|cd=i',
            'attack_speed|a=f@',        'increase_attack_speed|ias=f',
            'buff|b=f',
        );

        if ( !$ret ) {
            die "Something wrong with parameters [$args] at line $i.\n";
        }

        for (qw(max min attack_speed)) {
            unless ( defined $o{$_}->[0] ) {
                die "Mandatory parameter $_ is missing at line $i\n";
            }
        }

        for (qw(primary_stat)) {
            unless ( defined $o{$_} ) {
                die "Mandatory parameter $_ is missing at line $i\n";
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

        # FIXME
        $calc->{_args} = $args;

        $i++;
        push @calc, $calc;
    }

    return @calc;
}

=head1 SYNOPSIS

d3-damage-compare.pl

    --file | -f CONFIG

    --help | -h

=head2 CONFIG

Write configurations per line.

    $ cat my-barb-config
    -p 1200 -cc 38.5 -cd 265 -b 15 -ias 7.5 -mi 400 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1200 -cc 42.5 -cd 265 -b 15 -ias 7.5 -mi 600 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1250 -cc 38.5 -cd 305 -b 15 -ias 0   -mi 400 -ma 800 -a 1.20 -mi 350 -ma 750 -a 1.20
    -p 1250 -cc 48.5 -cd 165 -b 15 -ias 16  -mi 400 -ma 800 -a 1.53

=head2 Example

    d3-damage-diff.pl -f my-barb-config
    ==============================================================================
    -p 1200 -cc 38.5 -cd 265 -b 15 -ias 7.5 -mi 400 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    ==============================================================================
    Base Damage    :  6600.00 ( 7590.00)
    Critical Chance:    38.50
    Critical Damage: 24090.00 (27703.50)
    Avg            : 13333.65 (15333.70)
    APS            :     1.56 (1.47, 1.65)
    DPS            : 20825.49 (23949.32)

    ==============================================================================
    -p 1200 -cc 42.5 -cd 265 -b 15 -ias 7.5 -mi 600 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    ==============================================================================
    Base Damage    :  7200.00 ( 8280.00)     9.09%
    Critical Chance:    42.50               10.39%
    Critical Damage: 26280.00 (30222.00)     9.09%
    Avg            : 15309.00 (17605.35)    14.81%
    APS            :     1.56 (1.47, 1.65)   0.00% (  0.00%,   0.00%)
    DPS            : 23910.74 (27497.36)    14.81%

    ==============================================================================
    -p 1250 -cc 38.5 -cd 305 -b 15 -ias 0   -mi 400 -ma 800 -a 1.20 -mi 350 -ma 750 -a 1.20
    ==============================================================================
    Base Damage    :  7187.50 ( 8265.62)     8.90%
    Critical Chance:    38.50                0.00%
    Critical Damage: 29109.38 (33475.78)    20.84%
    Avg            : 15627.42 (17971.54)    17.20%
    APS            :     1.38 (1.38, 1.38) -11.64% ( -6.12%, -16.55%)
    DPS            : 21565.84 (24800.72)     3.56%

    ==============================================================================
    -p 1250 -cc 48.5 -cd 165 -b 15 -ias 16  -mi 400 -ma 800 -a 1.53
    ==============================================================================
    Base Damage    :  7500.00 ( 8625.00)    13.64%
    Critical Chance:    48.50               25.97%
    Critical Damage: 19875.00 (22856.25)   -17.50%
    Avg            : 13501.88 (15527.16)     1.26%
    APS            :     1.77 (1.77, 0.00)  13.63% ( 20.73%, -100.00%)
    DPS            : 23963.13 (27557.60)    15.07%
=cut
