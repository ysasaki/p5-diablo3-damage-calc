use 5.014;
use warnings;
use Test::More;

BEGIN { use_ok 'Diablo3::Damage::Weapon'; }

subtest 'main weapon' => sub {

    my $weapon = new_ok 'Diablo3::Damage::Weapon',
        [
        min          => 10,
        max          => 20,
        attack_speed => 1.00,
        ];

    can_ok $weapon, qw(min max attack_speed avg is_equipped);

    is $weapon->avg, ($weapon->min+$weapon->max)/2, 'avg ok';
    ok $weapon->is_equipped, 'is_equipped ok';
};

subtest 'off hand' => sub {

    my $weapon = Diablo3::Damage::Weapon->new(
        min          => undef,
        max          => undef,
        attack_speed => undef,
    );
    ok !$weapon->is_equipped, 'is not equipped';
};

done_testing;
