/**
 * N Body Gravity Simulator
 * Date: December 17, 2012
 * Version: 0.1
 * Authors: Luis Panadero Guardeño, luis (dot) panadero (at) gmail.com
 * License: GNU GENERAL PUBLIC LICENSE Version 3
 */

import std.stdio, std.math, std.datetime, std.random;
import std.getopt, std.conv, std.string;
import std.parallelism, std.algorithm, std.range;

import vector, entity;

enum Version = "0.1";

void main(string[] args) {

  Entity[] objects; /// Container of entities

  int NPoints = 4;  /// Every few points that are written in the output file

  double DeltaT = 60*60*24; /// Delta of Time, by default one Earth day
  size_t TIter = 100*365;   /// Total number of iterations, by default with default DeltaT -> 100 years
  double SoftConst = 1000;  /// Soft contant, by default is 1000 meters

  uint rSeed = unpredictableSeed; /// Seed of the rand generator
  size_t randBodies = 0;    /// Number of entities to be generated
  ptrdiff_t centerOn = -1;  /// Output coords relative to Entity X

  string iFile = "", oFile = "";  /// Output and Input filenames
  File input, output = stdout;    /// Output/Input files
  bool fWriteOutput = false;      /// Write coords to output file?

  writeln("N-Body simulator v", Version);
  
  // Small function that show the help option
  void ShowHelp() {
    writefln("Usage: %s [OPTION]...", args[0]);
    writeln("Calculate the N-Body simulation with the Newton gravity equations");
    writeln(
r"  -i, --input=FILE                  Input file with initial positions and velocity
                                    of every body
  -o, --output=FILE                 Output data file
  -d, --deltat=NUM                  Delta of Time used in each step. By default is
                                    86400 [s]
  -n, --num=NUM                     Total number of steps. by default is 36500, that
                                    with default DeltaT, is 100 years of simulation
  --points=NUM                      Defines every few points that are written to
                                    output file. 1 means that are used all points, 2
                                    that 1/2 of the total points not are written. By
                                    default is 4
  -e, --epsilon=NUM                 Softening factor used that avoid NaNs and Inf in
                                    calculations. By default is 1000 meters
  --rand=NUM                        If not are using a input file, then generate NUM
                                    random stellar mass bodies in a cube of 10 LY
  --seed=NUM                        Set a seed for the random generator
  --center=NUM                      Set the output coords relative to the entity NUM
                                    Useful to centre around a particular entity,
                                    like the Sun
  -h, --help                        Show this help");
    std.c.stdlib.exit(0);
  }

  // Get parameters with getopt
  getopt( args, 
      "input|i", &iFile,        // -iFILE
      "output|o", &oFile,       // -oFILE
      "deltat|d", &DeltaT,      // -dNUM 
      "num|n", &TIter,          // -nNUM
      "points", &NPoints,       // --points=NUM
      "epsilon|e", &SoftConst,  // -eNUM
      "rand", &randBodies,      // --rand=NUM
      "seed", &rSeed,           // --seed=NUM
      "center", &centerOn,      // --center=NUM
      "help|h", &ShowHelp,      // --help
      );

  // Sanitation of parameters
  if (TIter <= 0) {
    writeln("Invalid number of iterations ", TIter);
    std.c.stdlib.exit(-1);
  }

  if (DeltaT <= 0) {
    writeln("Invalid value of Delta of Time ", DeltaT);
    std.c.stdlib.exit(-1);
  }

  if (NPoints <= 0) {
    writeln("Invalid value N Points ", NPoints);
    writeln("Remember that 1 means that all points are stored in output file");
    std.c.stdlib.exit(-1);
  }

  // Opens output file
  if (oFile.length >0) {
    output = File(oFile, "w");
    fWriteOutput = true;
  }

  if (fWriteOutput)
    output.writeln("# N-Body simulator v", Version);

  if (iFile.length >0) { // Try to open the input file
    input = File(iFile, "r");
    objects = ReadInputFile(input, DeltaT);

  } else if (randBodies > 0) {  // Aren't any input file, so if the user asked rand 
                                // bodies, we generate it
    Random gen = Random(rSeed);

    if (fWriteOutput)
      output.writeln("# Seed=", rSeed);
    
    for(auto i =0; i < randBodies; i++) {
      // Stars between 0.1 y 20 Sun masses
      double mass = uniform(1e+29, 4e+31, gen);
    
      double px = uniform(-5e+16, 5e+16, gen); // Cuve of ~10*10*10Ly
      double py = uniform(-5e+16, 5e+16, gen);
      double pz = uniform(-5e+16, 5e+16, gen);
      // Light Year = 9,46e+15 m ~= 1e+16
    
      double vx = uniform(-1e+02, 1e+02, gen);
      double vy = uniform(-1e+02, 1e+02, gen);
      double vz = uniform(-1e+02, 1e+02, gen);
    
      objects ~= Entity(mass, Vector3(px, py, pz), Vector3(vx, vy, vz), DeltaT);
    }

  } else {  // Try to load a example simulation of out solar system with the Sun, 
            // 8 planets and recognized dwarf planets
    input = File("ssolar.sim", "r");
    objects = ReadInputFile(input, DeltaT);
    writeln("Loading our Solar System with the eight planets and the recognized 
dwarf planets");
  
  }
 
  SoftConst = SoftConst * SoftConst; // Soften Contants squared (so always is >= 0)

  if (fWriteOutput) {
    output.writeln("# N Bodies=", objects.length);
  
    if (centerOn >= 0) // Relative coords options, so we show it in output file
      output.writeln("# Coords relative to ", centerOn, " body");
    
    output.writeln("# DeltaT=", DeltaT, " NIter=", TIter, " Epsilon^2=", SoftConst, 
        " N Points Saved=", NPoints);
    output.writeln("# CPUs : ", totalCPUs);
    output.writeln("# X1 Y1 Z1  X2 Y2 Z2  X3 Y3 Z3 ....");
  
  }
  
  writeln("N Bodies=", objects.length);
  if (centerOn >= 0) // Relative coords options, so we show it in output file
    writeln("Coords relative to ", centerOn, " body");

  writeln("DeltaT=", DeltaT, " NIter=", TIter, " Epsilon^2=", SoftConst, 
      " N Points Saved=", NPoints);
  writeln("CPUs : ", totalCPUs);

  // Shares equitably the load between all CPUS
  auto workUnitSize = max( 1, cast(int)(objects.length / totalCPUs)); 

  immutable iDeltaT = DeltaT;       // Immutable data to avoid false sharing
  immutable iEpsilon = SoftConst;

  StopWatch total, tacel, tintegrator;

  version (PFor) {
    writeln("\tUsing Parallel Foreach");
  } else {
    writeln("\tUsing Serial For");
  }

  total.start();
  // Begin to calculate all interactions 
  for (auto i=0; i < TIter; i++) {
    // Calculate all resultant accelerations over all bodies
    tacel.start();
    version (PFor) { // Parallel version
      foreach (ref e; taskPool.parallel(objects, workUnitSize)) {
        e.CalcAcel(objects, iEpsilon);
      }
    
    } else { // Serial version
      foreach (ref e; objects) {
        e.CalcAcel(objects, iEpsilon);
      }
    
    }
    tacel.stop();

    // Write to output file, if we can
    if (fWriteOutput && (i % NPoints) == 0) { 
      foreach(ref e; objects) {
        if (centerOn >= 0) { // Relative position to X body
          auto offset = e.pos[0] - objects[centerOn].pos[0];
          output.write(offset.toString(), "  ");
        } else {
          output.write(e.pos[0].toString(), "  ");
        }
      }
      output.writeln();
    }

    // Integrate the position of each entity
    tintegrator.start();
    version (PFor) { // Parallel version
      foreach (ref e; taskPool.parallel(objects, workUnitSize)) {
        e.Integrador3Orden (iDeltaT);
      }
    
    } else { // Serial Version
      foreach (ref e; objects) {
        e.Integrador3Orden (iDeltaT);
      }
    
    }
    tintegrator.stop();

  }
  total.stop();

  // We output the times that we measured
  if (fWriteOutput) {
    output.writeln("# Total Time = ", total.peek().msecs, " [ms]");
    output.writeln("# Calc Acel Time = ", tacel.peek().msecs, " [ms]");
    output.writeln("# Calc Pos Time = ", tintegrator.peek().msecs, " [ms]");
  }

  writeln("Total Time = ", total.peek().msecs, " [ms]");
  writeln("Calc Acel Time = ", tacel.peek().msecs, " [ms]");
  writeln("Calc Pos Time = ", tintegrator.peek().msecs, " [ms]");
}

/**
 * Read a input file that contains a list of bodies with positions and speeds
 * Params:
 *    input = Input file
 *    deltaT = Delta of Time, used to calculate the previous position of bodies
 * Returns: A dynamic array of bodies with all valid entities/bodies
 */
Entity[] ReadInputFile (File input, double deltaT) {
  Entity[] bodies; 

  foreach(linea; input.byLine()) { // Lee lineas
    Vector3 pos, vel;
    double mass;

    if (linea.length <= 0 || linea[0] == '#')
      continue; // A comment or a empty line

    // We expect to have mass, position and velocity in 3d in a single line
    foreach(i ,palabra; split(stripLeft(linea))) { // Split in words
      if (i > 6) // Wops something wrong or not useful
        break;

      switch (i) {
        case 0: // Mass
          mass = parse!double(palabra);
          break;
        case 1: // Pos X
          pos.X = parse!double(palabra);
          break;
        case 2: // Pos Y
          pos.Y = parse!double(palabra);
          break;
        case 3: // Pos Z
          pos.Z = parse!double(palabra);
          break;
        case 4: // Vel X
          vel.X = parse!double(palabra);
          break;
        case 5: // Vel Y
          vel.Y = parse!double(palabra);
          break;
        case 6: // Vel Z
          vel.Z = parse!double(palabra);
          break;
        default:
      }
    }

    bodies ~= Entity(mass, pos, vel, deltaT);
  }

  return bodies;
}
