D3::Damage::Calc version 0.02
=============================

The README is used to introduce the module and provide instructions on
how to install the module, any machine dependencies it may have (for
example C compilers and installed libraries) and any other information
that should be provided before the module is installed.

A README file is required for CPAN modules since CPAN extracts the
README file from a module distribution so that people browsing the
archive can use it get an idea of the modules uses. It is usually a
good idea to provide version information here so that people can
decide whether fixes for the module are worth downloading.

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

    d3-damage.pl -p 1100 -cc 12.5 -cd 97 -b 15 -mi 300 -ma 700 -a 1.35 

_Dual Wielding_

    d3-damage.pl -p 1200 -cc 38.5 -cd 265 -b 15 \
    -mi 400 -ma 800 -a 1.20 \
    -mi 300 -ma 700 -a 1.35 

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

Put the correct copyright and licence information here.

Copyright (C) 2012 by Yoshihiro Sasaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.
