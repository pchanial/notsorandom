=============
Not So Random
=============

This module provides pseudo-random generators for the uniform and normal distributions, whose values are cyclicly read from external files.
Currently, such "generators" have been written in Python and IDL languages.

    #!/usr/bin/env python

    from notsorandom import normal, uniform
    sample_normal = normal()
    sample_uniform = uniform()

Such module is of interest to ensure that stochastic routines written in two different languages lead to identical results.

