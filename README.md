Diablo3::Damage::Calc version 0.12
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

    $ d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -ias 7.5 -mi 300 -ma 700 -a 1.35
    Base Damage    :  5500.00 ( 6325.00)
    Critical Chance:    12.50
    Critical Damage: 10835.00 (12460.25)
    Avg            :  6166.88 ( 7091.91)
    APS            :     1.45 (1.45, 0.00)
    DPS            :  8949.68 (10292.13)

_Dual Wielding_

    $ d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 -ias 7.5 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35
    Base Damage    :  6600.00 ( 7590.00)
    Critical Chance:    38.50
    Critical Damage: 24090.00 (27703.50)
    Avg            : 13333.65 (15333.70)
    APS            :     1.56 (1.47, 1.65)
    DPS            : 20825.49 (23949.32)


d3-damage-compare.pl
--------------------

First, you need to write a configuration file like below.

    $ cat example/compare-config
    -p 1200 -cc 38.5 -cd 265 -b 15 -ias 7.5 -mi 400 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1200 -cc 42.5 -cd 265 -b 15 -ias 7.5 -mi 600 -ma 800 -a 1.20 -mi 300 -ma 700 -a 1.35
    -p 1250 -cc 38.5 -cd 305 -b 15 -ias 0   -mi 400 -ma 800 -a 1.20 -mi 350 -ma 750 -a 1.20
    # add support for one-line comments beginning with #
    #-p 1250 -cc 48.5 -cd 165 -b 30 -ias 16  -mi 400 -ma 800 -a 1.20
    -p 1250 -cc 48.5 -cd 165 -b 15 -ias 16  -mi 400 -ma 800 -a 1.53


Next, run `d3-damage-compare.pl -f /path/to/your/config`.

    $ d3-damage-compare.pl -f example/compare-config
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
