use 5.014002;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME          => 'Diablo3::Damage::Calc',
    VERSION_FROM  => 'lib/Diablo3/Damage/Calc.pm',
    AUTHOR        => 'Yoshihiro Sasaki <ysasaki at cpan.org>',
    PREREQ_PM     => { 'Class::Accessor::Lite' => 0 },
    EXE_FILES     => ['d3-damage.pl'],
    LICENSE       => 'perl',
    META_MERGE => {
        resources => {
            license => 'http://dev.perl.org/licenses/',
            bugtracker =>
                'https://github.com/ysasaki/p5-diablo3-damage-calc/issues',
            repository => 'git://github.com/ysasaki/p5-diablo3-damage-calc.git',
        },
    },
);
