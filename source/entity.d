
import std.math, std.range, std.algorithm, std.parallelism;
import vector;

/**
 * Represents a physical object in 3d Space with a mass using SI units
 * Authors: Luis Panadero Guardeño, luis (dot) panadero (at) gmail.com
 * License: GNU GENERAL PUBLIC LICENSE Version 3
 */
struct Entity {
  public:
 
  static enum size_t Steps = 2;       /// Number of Steps used by multi-step integration algorithm
  static enum double G = 6.67384e-11; /// Gravitational Const. in m^3 kg^-1 s^-2

  double mass;                        /// Mass in Kgr
  
  Vector3[Steps] pos;  /// Queue of the last positions in 3d space, in Meters
  Vector3 acel;        /// Accelerations in m/s^2

  /**
   * Construct a physic entity and extrapolate the last position using his velocity Vector
   * Params:
   *    pos = Last position Vector
   *    vel = Velocity Vector
   *    DeltaT = Delta of Time (t0 - t-1) for the previous position, in seconds
   */
  public this (double mass, Vector3 pos,  Vector3 vel, double DeltaT) {
    this.mass = mass;

    this.pos[0] = pos;
    this.pos[1] = (pos - vel * DeltaT);

    this.acel = Vector3(0,0,0);
  }

  /**
   * Calculate the difference between two positions in the queue
   * Can be used to calc median Velocity vector
   * Params:
   *    i0 = Index of the first position
   *    i1 = Index of the last position
   * Returns: pos[i0] - pos[i1]
   */
  Vector3 DiffPos(size_t i0, size_t i1) {
    return (pos[i0] - pos[i1]);
  }

  /**
   * Calculate the resultant acceleration over this entity
   * Params:
   *  objects[] = List of entities that affects this entity
   *  epsilon2 = Soft. Constant that avoids infinite speeds and stupid high speeds when two entities are too near.
   */
  void CalcAcel (Entity[] objects, immutable double epsilon2 = 1) {
    Vector3 newAcel = Vector3(0,0,0);
    
    foreach (ref o; objects) {
      if (epsilon2 > 0 || o !is this) { // if epsilon2 is 0, then we must avoid calc gravity aceleration of this over this that is infinity
        Vector3 r = o.pos[0] - pos[0];
        newAcel = newAcel + r * (o.mass / pow((r.sq_length + epsilon2), 1.5));  
      }
    }

    newAcel = newAcel * G;

    acel = newAcel;
  }

  /**
   * Integrate the position function of this body using the last positions
   * See_Also : http://burtleburtle.net/bob/math/multistep.html
   * Params:
   *  DeltaT = Delta of Time between positions
   */
  void Integrador3Orden (immutable double DeltaT) {
    // Using third order multipass -> Euler integration
    Vector3 newPos;
    // DiffPos(0,1) = Speed[-0.5] * DeltaT
    newPos = pos[0] + DiffPos(0, 1) + (acel * DeltaT * DeltaT);
    
    pos[1] = pos[0]; // Elimina el ultimo
    pos[0] = newPos; // Inserta la nueva posicion
    

  }
    
}
