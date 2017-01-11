life.hs
--------------------------

A dead-simple simulator for Conway's Game of Life in Haskell.

Compiling:
```
$ ghc --make life.hs
```

Usage:
```
./life < seeds/PulsarSeed.txt
```
Or
```
$ runhaskell life.hs < seeds/GliderSeed.txt
```

Seeds are space separeted matrices of 0 and 1 representing dead/alive cell.

