Diablo3::Damage::Calc version 0.10
==================================

INSTALLATION
------------

To install this module type the following:

    git clone git://github.com/ysasaki/p5-diablo3-damage-calc.git
    cd p5-diablo3-damage-calc
    cpanm .
    d3-damage.pl --help

HOW TO USE
----------

d3-damage.pl
------------

_One Hand_

    $ d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -mi 300 -ma 700 -a 1.35
    Base Damage    :  5500.00 ( 6325.00)
    Critical Chance:    12.50
    Critical Damage: 10835.00 (12460.25)
    Avg            :  6166.88 ( 7091.91)
    APS            :     1.35 (1.35, 0.00)
    DPS            :  8325.28 ( 9574.07)

_Dual Wielding_

    $ d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35
    Base Damage    :  6600.00 ( 7590.00)
    Critical Chance:    38.50
    Critical Damage: 24090.00 (27703.50)
    Avg            : 13333.65 (15333.70)
    APS            :     1.47 (1.38, 1.55)
    DPS            : 19550.46 (22483.03)


d3-damage-compare.pl
--------------------

First, you need to write a configuration file like below.

    $ cat example/compare-config
    -p 1200 -cc 38.5 -cd 265 -b 15 -mi 400 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1200 -cc 42.5 -cd 265 -b 15 -mi 600 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1250 -cc 38.5 -cd 305 -b 15 -mi 400 -ma 800 -a 1.20 -mi 350 -ma 750 -a 1.20
    -p 1250 -cc 48.5 -cd 165 -b 15 -mi 400 -ma 800 -a 1.53

Next, run `d3-damage-compare.pl -f /path/to/your/config`.

    $ d3-damage-compare.pl -f example/compare-config
    ==============================================================================
    -p 1200 -cc 38.5 -cd 265 -b 15 -mi 400 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    ==============================================================================
    Base Damage    :  6600.00 ( 7590.00)
    Critical Chance:    38.50
    Critical Damage: 24090.00 (27703.50)
    Avg            : 13333.65 (15333.70)
    APS            :     1.47 (1.38, 1.55)
    DPS            : 19550.46 (22483.03)

    ==============================================================================
    -p 1200 -cc 42.5 -cd 265 -b 15 -mi 600 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    ==============================================================================
    Base Damage    :  7200.00 ( 8280.00)     9.09%
    Critical Chance:    42.50               10.39%
    Critical Damage: 26280.00 (30222.00)     9.09%
    Avg            : 15309.00 (17605.35)    14.81%
    APS            :     1.47 (1.38, 1.55)   0.00% (  0.00%,   0.00%)
    DPS            : 22446.82 (25813.84)    14.81%

    ==============================================================================
    -p 1250 -cc 38.5 -cd 305 -b 15 -mi 400 -ma 800 -a 1.20 -mi 350 -ma 750 -a 1.20
    ==============================================================================
    Base Damage    :  7187.50 ( 8265.62)     8.90%
    Critical Chance:    38.50                0.00%
    Critical Damage: 29109.38 (33475.78)    20.84%
    Avg            : 15627.42 (17971.54)    17.20%
    APS            :     1.38 (1.38, 1.38)  -5.88% (  0.00%, -11.11%)
    DPS            : 21565.84 (24800.72)    10.31%

    ==============================================================================
    -p 1250 -cc 48.5 -cd 165 -b 15 -mi 400 -ma 800 -a 1.53
    ==============================================================================
    Base Damage    :  7500.00 ( 8625.00)    13.64%
    Critical Chance:    48.50               25.97%
    Critical Damage: 19875.00 (22856.25)   -17.50%
    Avg            : 13501.88 (15527.16)     1.26%
    APS            :     1.53 (1.53, 0.00)   4.35% ( 10.87%, -100.00%)
    DPS            : 20657.87 (23756.55)     5.66%


ABOUT FORMULA
-------------

See [Calculating Dual Wield Character DPS](http://gaming.stackexchange.com/questions/71589/calculating-dual-wield-character-dps).

TODO
----

 - Support Wizard Source and Witch Doctor Mojo

DEPENDENCIES
------------

This module requires these other modules and libraries:

    Class::Accessor::Lite

COPYRIGHT AND LICENCE
---------------------

Copyright (C) 2012 by Yoshihiro Sasaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.
