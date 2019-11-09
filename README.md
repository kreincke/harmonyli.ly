# harmonyli.ly

A **library** for inserting **Functional Harmony Analysis Symbols** into musical 
scores encoded in and created by LilyPond.

![ALT](img/cadenca-by-harmonylily.png "harmonyli.ly example cadenca")

## Installation
* Checkout the repository
* copy the file harmonyli.ly into any directory from which you want to include it
* Insert `include "YOURPATH/harmonyli.ly"` into your LilyPond file

## License:

_harmonyli.ly_ is distributed under the terms of the MIT license or under 
the terms of the GPLv3 license. As long as harmonyli.ly is distributed under 
both licenses, the recipient has the right to chose the license under which he
wants to use the work.

For details see the file [LICENSING](./LICENSING).

## Examples:

The packages contains 3 examples by which the user can learn how to use
the library `harmonyli.ly`. Like all other LilyPond files, each example 
`example.ly`can be compiled by the command line order `make example.pdf` 
respectively `make example.png`:

* **cadenca.ly** :- the general reference cadence 
  ( [score](./cadenca.ly) [result](./img/cadenca.png) )
* **sn967.ly** :- the re-implementation of a former example
  ( [score](./sn967.ly) [result](./img/sn967.png) )
* **modulation.ly** :- an example explaining how to deal with modulations
  ( [score](./modulation.ly) [result](./img/modulation.png) )


## Usage:

See `doc/harmonylily-tutorial.pdf`
