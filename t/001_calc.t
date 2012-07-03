use 5.014;
use warnings;
use Test::More;
use Diablo3::Damage::Weapon;

BEGIN { use_ok 'Diablo3::Damage::Calc'; }

subtest 'one hand' => sub {
    my $calc = new_ok 'Diablo3::Damage::Calc',
        [
        main_weapon => Diablo3::Damage::Weapon->new(
            min          => 10,
            max          => 10,
            attack_speed => 1.00
        ),
        off_hand => Diablo3::Damage::Weapon->new(
            min          => undef,
            max          => undef,
            attack_speed => undef,
        ),
        primary_stat        => 100,
        critical_hit_chance => 5,
        critical_hit_damage => 50,
        buff                => 10,
        ];

    can_ok $calc, qw(
        main_weapon
        off_hand
        primary_stat
        critical_hit_chance
        critical_hit_damage
        buffed
        base_damage
        critical_damage
        critical_hit_damage_ratio
        average_damage
        attack_per_second
    );

    is $calc->buffed, 1 + $calc->buff / 100, 'buffed ok';

    my $base = $calc->main_weapon->avg * $calc->primary_stat / 100;
    is_deeply
        [ $calc->base_damage ],
        [ $base, $base * $calc->buffed ],
        'base damage ok';

    is $calc->critical_hit_damage_ratio, 1 + $calc->critical_hit_damage / 100,
        'critical_hit_damage_ratio ok';

    my $critical = $base * $calc->critical_hit_damage_ratio;
    is_deeply
        [ $calc->critical_damage ],
        [ $critical, $critical * $calc->buffed ],
        'critical damage ok';

    my $chance = $calc->critical_hit_chance;
    my $avg = ( 1 - $chance / 100 ) * $base + ( $chance / 100 ) * $critical;
    is_deeply
        [ $calc->average_damage ],
        [ $avg, $avg * $calc->buffed ],
        'average damage ok';

    is_deeply
        [ $calc->attack_per_second ],
        [
        $calc->main_weapon->attack_speed, $calc->main_weapon->attack_speed,
        0
        ],
        'attack_per_second ok';
};

subtest 'dual wielding' => sub {
    my $calc = Diablo3::Damage::Calc->new(
        main_weapon => Diablo3::Damage::Weapon->new(
            min          => 10,
            max          => 20,
            attack_speed => 1.20
        ),
        off_hand => Diablo3::Damage::Weapon->new(
            min          => 20,
            max          => 30,
            attack_speed => 1.00,
        ),
        primary_stat        => 100,
        critical_hit_chance => 5,
        critical_hit_damage => 50,
        buff                => 10,
    );

    my $base = ( $calc->main_weapon->avg + $calc->off_hand->avg ) / 2
        * $calc->primary_stat / 100;
    is_deeply
        [ $calc->base_damage ],
        [ $base, $base * $calc->buffed ],
        'base damage ok';

    my $main_speed = $calc->main_weapon->attack_speed * 1.15;
    my $off_speed  = $calc->off_hand->attack_speed * 1.15;
    is_deeply
        [ $calc->attack_per_second ],
        [ ( $main_speed + $off_speed ) / 2, $main_speed, $off_speed ],
        'attack_per_second ok';
};

done_testing;
