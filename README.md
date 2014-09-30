# nBodySim : N Body problem Simulator

nBodySim is a small simulator programa capable of handling huge number of bodies (>1000). It's capable of using multiple cores of a modern many-core CPU. For this, nBodySim is programed using D Language 2, using the std.parallelism library.

This software was compiled with gdc 4.6.3 and dmd 2.0.65,  and tested on some machines using Ubuntu x64 14.04, 12.04, 12.10 and Linux ROCKS 6.0 x64.

To build it, use DUB. So do a simple :
    dub build=release

It will generate the program using parallel for. If you like  to compare with athe serial version, you can launch dub with --configure=nBodySim-serial

## Usage
    ./nBodySim [OPTION]...
- -i, --input=FILE                  Input file with initial positions and velocity
                                    of every body
- -o, --output=FILE                 Output data file
- -d, --deltat=NUM                  Delta of Time used in each step. By default is
                                    86400 [s]
- -n, --num=NUM                     Total number of steps. by default is 36500, that
                                    with default DeltaT, is 100 years of simulation
- --points=NUM                      Defines every few points that are written to
                                    output file. 1 means that are used all points, 2
                                    that 1/2 of the total points not are written. By
                                    default is 4
- -e, --epsilon=NUM                 Softening factor used that avoid NaNs and Inf in
                                    calculations. By default is 1000 meters
- --rand=NUM                        If not are using a input file, then generate NUM
                                    random stellar mass bodies in a cube of 10 LY
- --seed=NUM                        Set a seed for the random generator
- --center=NUM                      Set the output coords relative to the entity NUM
                                    Useful to centre around a particular entity,
                                    like the Sun
- -h, --help                        Show this help

### Examples
- Execute a simulation of 100 years with a DeltaT of a 1 day of our solar system fixing the Sun in the (0,0,0) position
        ```./nBodySim --input ssolar.sim --center 0 --output ssolar.out```
- Execute a simulation of 10000 years with a DeltaT of 100 days of a ranmdon set of 500 stars
        ```./nBodySim --rand 500 -d8640000 --output rand.out```

## Output files
For the moment, nBodySim it's outputing files that are compatible with [GnuPlot](http://www.gnuplot.info/), where in a row we can found the position of *every* object in the simulation for a determinated moment ofthe simulation.
It's easy to plot hte data using 'splot' command of gnuplot, but be carefull about how many points (rows) are stored in the file, becasue GnuPlot can be easily swamped. I recomend using --points to skip points to be stored in the output file, and keep it easy to hnadle for the gnuplot at same tiem that allow to run long (big number of iterations).

### View output on gnuplot

 View the output data of the simulation of our solar system

```
set zrange [-8e+12:8e12]
set title "Solar System : 100 years"
splot "ssolar.out" u 1:2:3 t "Sun", \
"ssolar.out" u 4:5:6 w dots t "Mercury", \
"ssolar.out" u 7:8:9 w dots t "Venus", \
"ssolar.out" u 10:11:12 w dots t "Earth", \
"ssolar.out" u 13:14:15 w dots t "Moon", \
"ssolar.out" u 16:17:18 w dots t "Mars", \
"ssolar.out" u 19:20:21 w dots t "Jupiter", \
"ssolar.out" u 22:23:24 w dots t "Saturn", \
"ssolar.out" u 25:26:27 w dots t "Uranus", \
"ssolar.out" u 28:29:30 w dots t "Neptune", \
"ssolar.out" u 31:32:33 w dots t "Ceres", \
"ssolar.out" u 34:35:36 w dots t "Pluto", \
"ssolar.out" u 37:38:39 w dots t "Haumea", \
"ssolar.out" u 40:41:42 w dots t "Makemake", \
"ssolar.out" u 43:44:45 w dots t "Eris"
```

## TODO

- Make a animated viewer of generated data.
- Make a interactive mode that work with the viewer.
- Add an option to use relative coords around the barycenter of the all system.
- Implement collisions.
- Add other output format that can carry more usefull information.
- Add a way to do electroestatic simulations.
- Add a way to use a arbitrary precision calculations (GMP).

## Benchmark data

10 iterations :

FX-4100 quad core times :

Bodies : 1000
Serial = 573 ms
ParallelFor = 192 ms -> SpeedUp = 2.98

Bodies : 3000
Serial = 5106 ms
ParallelFor = 1745 ms -> SpeedUp = 2.92

Bodies : 10000
Serial = 57726 ms
ParallelFor = 20023 ms -> SpeedUp = 2.88


Opteron 16-core times :

Bodies : 1000
Serial =  682 ms
ParallelFor = 67 ms -> SpeedUp = 10,12

Bodies : 3000
Serial = 6083 ms
ParallelFor = 474 ms -> SpeedUp = 12,83

Bodies : 10000
Serial = 69728: ms
ParallelFor = 5232 ms -> SpeedUp = 13,32


With 1000 iterations :

FX-4100 quad core times :

Bodies : 100
Serial = 571 ms
ParallelFor = 234 ms -> SpeedUp = 2,44

Bodies : 1000
Serial = 57373 ms
ParallelFor = 19987 ms -> SpeedUp = 2,87


Opteron 16-core times :

Bodies : 100
Serial = 676 ms
ParallelFor = 296 ms -> SpeedUp = 2,28

Bodies : 1000
Serial = 67505 ms
ParallelFor = 5921 ms -> SpeedUp = 11,40


