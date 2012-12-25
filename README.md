# nBodySim : N Body problem Simulator

nBodySim is a small simulator programa capable of handling huge number of bodies (>1000) using multiple cores of a modern many-core CPU. For this, nBodySim is programed using D Language 2, using the std.parallelism library.

This software was compiled with gdc 4.6.3, and tested on some machines using Ubuntu x64 12.04, 12.10 and Linux ROCKS 6.0 x64.



## TODO

- Make a animated viewer of generated data.
- Make a interactive mode that work with the viewer.
- Add an option to use relative coords around the barycenter of the all system.
- Implement collisions.
- Add other output format that can carry more usefull information.
- Add a way to do electroestatic simulations.
- Add a way to use a arbitrary precision calculations (GMP).
- 
