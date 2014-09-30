nBodySim
========

N Body problem Simulator capable of handling huge number of bodies (>1000)

To build it, uses DUB. So do a simple :

    dub build=release

It will generate the program using parallel for. If you like  to compare with athe serial version, you can launch dub with --configure=nBodySim-serial


TODO
====
- Make a animated viewer of generated data
- Make a interactive mode that work with the viewer.
- Add an option to use relative coords around the barycenter of the all system.
- Implement collisions.
- Add other output format that can carry more usefull information
- Add a way to do electroestatic simulations


Benchmark data
====

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


