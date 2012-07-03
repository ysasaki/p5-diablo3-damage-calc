Diablo3::Damage::Calc version 0.02
=============================

INSTALLATION
------------

To install this module type the following:

    git clone git://github.com/ysasaki/p5-diablo3-damage-calc.git
    cd p5-diablo3-damage-calc
    cpanm .
    d3-damage.pl --help

HOW TO USE
----------

_One Hand_

    $ d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -mi 300 -ma 700 -a 1.35

    Base Damage: 5500.00(6325.00)
    Critical Chance: 12.50
    Critical Damage: 10835.00(12460.25)
    Avg: 6166.88(7091.91)
    APS: 1.35(1.35, 0.00)
    DPS: 8325.28(9574.07)

_Dual Wielding_

    $ d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35

    Base Damage: 6600.00(7590.00)
    Critical Chance: 38.50
    Critical Damage: 24090.00(27703.50)
    Avg: 13333.65(15333.70)
    APS: 1.47(1.38, 1.55)
    DPS: 19550.46(22483.03)

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
