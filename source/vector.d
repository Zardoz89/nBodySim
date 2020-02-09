import std.math, std.conv;

/**
 * Struct that represents a 3D Vector with his basic operations
 * Authors: Luis Panadero Guardeño, luis (dot) panadero (at) gmail.com
 * License: GNU GENERAL PUBLIC LICENSE Version 3
 */
public struct Vector3 {
  public:

  /// Cte. Vector Zero
  static enum Vector3 Zero = Vector3(0,0,0); 

  /** Each one of the coords of a 3d Vector */
  double X = 0;
  double Y = 0;
  double Z = 0;

  /**
   * Constructor
   * By default evaluates each coord to 0
   *
   * Examples :
   * --------------------
   * auto v1 = new Vector3();             // ( 0,  0,  0)
   * auto v2 = new Vector3(10);           // (10,  0,  0)
   * auto v3 = new Vector3(10,20);        // (10, 20,  0)
   * auto v4 = nec Vector4(10,20,30);     // (10, 20, 30)
   */
  this (double x, double y, double z) {
    X = x;
    Y = y;
    Z = z;
  }

  /**
   * Defines Equality of Vectors 
   * Params:
   *  rhs = Vector at right of '=='
   * Returns: True if both vector have exactly the same value
   */
  bool opEquals(ref const Vector3 rhs) const {
    if (X != rhs.X) return false;
    if (Y != rhs.Y) return false;
    if (Z != rhs.Z) return false;
    return true;	
  }

  /**
   * Approximated equality with a relative difference of 1e-02 and absolute of 1e-05
   * Params:
   *  rhs = Vector to compare with this vector
   * Returns: True if both vector have similar values
   */
  bool equal(ref const Vector3 rhs) const {
    return approxEqual(X, rhs.X) && approxEqual(Y, rhs.Y) && approxEqual(Z, rhs.Z);
  }
    
  /**
   * Approximated equality with controllable precision
   * Params:
   *  rhs = Vector to compare with this vector
   *  maxRelDiff = Max RELATIVE difference
   *  maxAbsDiff = Max ABSOLUTE difference (1e-05)
   * Returns: True if both vector have similar values
   */
  bool equal(ref const Vector3 rhs, double maxRelDiff, double maxAbsDiff = 1e-05) const {
    return approxEqual(X, rhs.X, maxRelDiff, maxAbsDiff) && 
      approxEqual(Y, rhs.Y, maxRelDiff, maxAbsDiff) && 
      approxEqual(Z, rhs.Z, maxRelDiff, maxAbsDiff);
  }

  /**
   * Define unary operators + and -
   */
  Vector3 opUnary(string op) ()
    if (op == "+" || op == "-") {
      return Vector3( mixin(op~"X"), mixin(op~"Y"), mixin(op~"Z"));
  }

  /**
   * Define binary operator + and -
   */
  Vector3 opBinary(string op) (in Vector3 rhs) {
    static if (op == "+") {
      return Vector3( X+rhs.X, Y+rhs.Y, Z+rhs.Z);	
    } else static if (op == "-") {
      return Vector3( X-rhs.X, Y-rhs.Y, Z-rhs.Z);	
    } else static assert(0, "Operator "~op~" not implemented"); 
          
  }

  /**
   * Define multiplication by a Scalar value
   */
  Vector3 opBinary(string op) (in double rhs)
    if (op == "*" ) {
      return Vector3(X *rhs, Y *rhs, Z *rhs);	
  }

  // Misc **********************************************************************
  
  /**
   * Checks that the vector not have a weird NaN value
   * Returns: True if this vector not have a NaN value
   */
  @property bool isOk() {
    return !(isNaN(X) || isNaN(Y) || isNaN(Z));
  }
  
  /**
   * Checks that the vector have finite values
   * Returns: True if this vector have finite values (not infinite value or NaNs)
   */
  @property bool isFinite() {
    return (std.math.isFinite(X) && std.math.isFinite(Y) && std.math.isFinite(Z));
  }

  /**
   * Actual Length of this Vector
   * Returns: the actual length of this Vector
   */
  @property double length() const {
    return sqrt(sq_length);
  }
  
  /**
   * Squared length of this Vector
   * Returns: the actual squared length of this Vector
   */
  @property double sq_length() const {
    return X*X + Y*Y + Z*Z;
  }

  /**
   * Returns: a String representation of the Vector
   */
  string toString() {
    return text(X, " ", Y, " " ,Z);
  }

}
