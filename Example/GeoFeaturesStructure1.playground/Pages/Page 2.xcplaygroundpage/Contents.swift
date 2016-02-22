//: [Previous](@previous)

import Swift
import Foundation


/*:
Precision
*/
public protocol Precision {
    
    @warn_unused_result
    func convert(value: Double) -> Double
    
}
public func ==<T1 : protocol<Precision, Hashable>, T2 : protocol<Precision, Hashable>>(lhs: T1, rhs: T2) -> Bool {
    if (lhs.dynamicType == rhs.dynamicType) {
        return lhs.hashValue == rhs.hashValue
    }
    return false
}

public struct FixedPrecision : Precision, Equatable, Hashable  {
    
    public let scale: Double
    
    public var hashValue: Int { get { return 31.hashValue + scale.hashValue } }
    
    public init(scale: Double) {
        self.scale = scale
    }
    
    public func convert(value: Double) -> Double {
        return round(value * scale) / scale
    }
}
extension FixedPrecision : CustomStringConvertible, CustomDebugStringConvertible {
    public var description : String {  return "\(self.dynamicType)(scale: \(self.scale))" }
    public var debugDescription : String {  return self.description }
}

public struct FloatingPrecision : Precision, Equatable, Hashable  {
    
    public var hashValue: Int { get { return 31.hashValue } }
    
    public init() {}
    
    public func convert(value: Double) -> Double {
        return value
    }
}
extension FloatingPrecision : CustomStringConvertible, CustomDebugStringConvertible {
    public var description : String { return "\(self.dynamicType)" }
    public var debugDescription : String { return self.description }
}

/*:
Coordinate
*/
public protocol Coordinate  {
    typealias TupleType
    
    var x: Double { get }
    var y: Double { get }
    
    var tuple: TupleType { get }

    func ==(lhs: Self, rhs: Self) -> Bool
}

/*:
3D
*/
public protocol ThreeDimensional {
    var z: Double { get }
}

/*:
Measured
*/
public protocol Measured {
    var m: Double { get }
}

/*:
Internal private
*/
public protocol _CoordinateConstructable {
    typealias TupleType
    
    init(other: Self, precision: Precision)
    init(tuple: TupleType, precision: Precision)
}

/*:
Coordinate2D
*/
public struct Coordinate2D : Coordinate, _CoordinateConstructable {
    public typealias TupleType = (x: Double, y: Double)
    
    public let x: Double
    public let y: Double
    
    public var tuple: TupleType { get { return (self.x, self.y) } }
    
    public init(other: Coordinate2D, precision: Precision) {
        self.x = precision.convert(other.x)
        self.y = precision.convert(other.y)
    }
    public init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
    }
}
public func ==(lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
extension Coordinate2D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "(x: \(self.x), y: \(self.y))"  }
    public var debugDescription : String { return self.description  }
}

/*:
Coordinate2DM
*/
public struct Coordinate2DM : Coordinate, Measured, _CoordinateConstructable  {
    public typealias TupleType = (x: Double, y: Double, m: Double)
    
    public let x: Double
    public let y: Double
    public let m: Double
    
    public var tuple: TupleType { get { return (self.x, self.y, self.m) } }
    
    public init(other: Coordinate2DM, precision: Precision) {
        self.x = precision.convert(other.x)
        self.y = precision.convert(other.y)
        self.m = precision.convert(other.m)
    }
    public init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
        self.m = precision.convert(tuple.m)
    }
}
public func ==(lhs: Coordinate2DM, rhs: Coordinate2DM) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.m == rhs.m
}
extension Coordinate2DM : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "(x: \(self.x), y: \(self.y), m: \(self.m))"  }
    public var debugDescription : String { return self.description  }
}

/*:
Coordinate3D
*/
public struct Coordinate3D : Coordinate, ThreeDimensional, _CoordinateConstructable {
    public typealias TupleType = (x: Double, y: Double, z: Double)
    
    public let x: Double
    public let y: Double
    public let z: Double
    
    public var tuple: TupleType { get { return (self.x, self.y, self.z) } }

    public init(other: Coordinate3D, precision: Precision) {
        self.x = precision.convert(other.x)
        self.y = precision.convert(other.y)
        self.z = precision.convert(other.z)
    }
    public init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
        self.z = precision.convert(tuple.z)
    }
}
public func ==(lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
extension Coordinate3D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "(x: \(self.x), y: \(self.y), z: \(self.z))"  }
    public var debugDescription : String { return self.description  }
}

/*:
Coordinate3DM
*/
public struct Coordinate3DM : Coordinate, ThreeDimensional, Measured, _CoordinateConstructable {
    public typealias TupleType = (x: Double, y: Double, z: Double, m: Double)
    
    public let x: Double
    public let y: Double
    public let z: Double
    public let m: Double
    
    public var tuple: TupleType { get { return (self.x, self.y, self.z, self.m) } }

    public init(other: Coordinate3DM, precision: Precision) {
        self.x = precision.convert(other.x)
        self.y = precision.convert(other.y)
        self.z = precision.convert(other.z)
        self.m = precision.convert(other.m)
    }
    public init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
        self.z = precision.convert(tuple.z)
        self.m = precision.convert(tuple.m)
    }
}
public func ==(lhs: Coordinate3DM, rhs: Coordinate3DM) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.m == rhs.m
}
extension Coordinate3DM : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "(x: \(self.x), y: \(self.y), z: \(self.z), m: \(self.m))"  }
    public var debugDescription : String { return self.description  }
}

/**
 Double System Types
 
 These are used by the algorythms when they are applyed to the types
 */
public protocol CoordinateReferenceSystem {}

public struct Cartesian: CoordinateReferenceSystem {}

public struct Ellipsoidal: CoordinateReferenceSystem {}

public struct Spherical: CoordinateReferenceSystem {}

public struct Vertical: CoordinateReferenceSystem {}

public struct Polar: CoordinateReferenceSystem {}


/**
Default Precision for all class
*/
let defaultPrecision = FloatingPrecision()

/**
Default CoordinateReferenceSystem
*/
let defaultCoordinateReferenceSystem = Cartesian()


/*:
Geometry
*/
public protocol Geometry {
    
    /**
     The Precision used to store the coordinates for this Geometry
     */
    var precision: Precision { get }
    
    /**
     The Double Reference System used in algorithms applied to this GeoemetryType
     */
    var coordinateReferenceSystem: CoordinateReferenceSystem { get }
    
    /**
     - Returns true if this Geometry is an empty Geometry.
     */
    @warn_unused_result
    func isEmpty() -> Bool
    
    /**
     - Returns: true if this GeoemetryType instance is equal the other Geometry instance.
     */
    @warn_unused_result
    func ==(lhs: Geometry, rhs: Geometry) -> Bool
    
    /**
     - Returns: true if this GeoemetryType instance is equal the other Geometry instance.
     */
    @warn_unused_result
    func equals(other: Geometry) -> Bool
}
public func ==(lhs: Geometry, rhs: Geometry) -> Bool {
    return lhs.equals(rhs)
}

/*:
Point
*/
public struct Point<CoordinateTupleType : protocol<Coordinate, _CoordinateConstructable>> : Geometry {
    
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem
    
    public var x: Double { get { return coordinate.x } }
    public var y: Double { get { return coordinate.y } }
    
    public init(coordinate: CoordinateTupleType.TupleType, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        self.coordinate = CoordinateTupleType(tuple: coordinate, precision: self.precision)
        
    }
    public init(coordinate: CoordinateTupleType, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        self.coordinate = CoordinateTupleType(other: coordinate, precision: self.precision)
    }
    
    private let coordinate: CoordinateTupleType
}
extension Point where CoordinateTupleType : ThreeDimensional {
    public var z: Double { get { return coordinate.z } }
}
extension Point where CoordinateTupleType : Measured {
    public var m: Double { get { return coordinate.m } }
}
extension Point /* : Geometry */ {
    
    public func isEmpty() -> Bool {
        return false
    }
    public func equals(other: Geometry) -> Bool {
        if let other = other as? Point {
            return self.coordinate == other.coordinate
        }
        return false
    }
}
extension Point : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "\(self.dynamicType)(\(self.coordinate))"  }
    public var debugDescription : String { return self.description  }
}

public protocol Curve {
    
    /**
     The length of this Curve calaculated using its associated CoordinateReferenceSystem.
     */
    @warn_unused_result
    func length() -> Double
}

/*:
LineString
*/
public struct LineString<CoordinateTupleType : protocol<Coordinate, _CoordinateConstructable>> {
    
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem
    
    private var coordinates = ContiguousArray<CoordinateTupleType>()
    
    init(coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
    }
    
    init<S : SequenceType where S.Generator.Element == CoordinateTupleType.TupleType>(coordinates: S, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        
        var generator = coordinates.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(tuple: coordinate, precision: self.precision))
        }
    }
    init<C : CollectionType where C.Generator.Element == CoordinateTupleType.TupleType>(coordinates: C, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        
        var generator = coordinates.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(tuple: coordinate, precision: self.precision))
        }
    }
    
    init<S : SequenceType where S.Generator.Element == CoordinateTupleType>(coordinates: S, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        
        var generator = coordinates.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(other: coordinate, precision: self.precision))
        }
    }
    init<C : CollectionType where C.Generator.Element == CoordinateTupleType>(coordinates: C, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        
        var generator = coordinates.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(other: coordinate, precision: self.precision))
        }
    }
}
extension LineString : CollectionType, MutableCollectionType, _DestructorSafeContainer {
    
    /**
     Always zero, which is the index of the first element when non-empty.
     */
    public var startIndex : Int { return self.coordinates.startIndex }
    
    /**
     A "past-the-end" element index; the successor of the last valid subscript argument.
     */
    public var endIndex   : Int { return self.coordinates.endIndex }
    
    public subscript(position : Int) -> CoordinateTupleType {
        get         { return self.coordinates[position] }
        set (value) { self.coordinates[position] = value }
    }
    
    public subscript(range: Range<Int>) -> ArraySlice<CoordinateTupleType> {
        get         { return self.coordinates[range] }
        set (value) { self.coordinates[range] = value }
    }
    
    public func generate() -> IndexingGenerator<ContiguousArray<CoordinateTupleType>> {
        return self.coordinates.generate()
    }
}
extension LineString : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "\(self.dynamicType)(\(self.coordinates.description))" }
    public var debugDescription : String { return self.description }
}
extension LineString  {
    
    /**
     - Returns: The number of Coordinate3D objects.
     */
    public var count: Int {
        get { return self.coordinates.count }
    }
    
    /**
     - Returns: The current minimum capacity.
     */
    public var capacity: Int {
        get { return self.coordinates.capacity }
    }
    
    /**
     Reserve enough space to store `minimumCapacity` elements.
     
     - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func reserveCapacity(minimumCapacity: Int) {
        self.coordinates.reserveCapacity(minimumCapacity)
    }
    
    /**
     Reserve enough space to store `minimumCapacity` elements.
     
     - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func append(newElement: CoordinateTupleType) {
        self.coordinates.append(CoordinateTupleType(other: newElement, precision: self.precision))
    }
    
    /**
     Reserve enough space to store `minimumCapacity` elements.
     
     - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func append(newElement: CoordinateTupleType.TupleType) {
        self.coordinates.append(CoordinateTupleType(tuple: newElement, precision: self.precision))
    }
    
    /**
     Append the elements of `newElements` to this LineString.
     */
    public mutating func appendContentsOf<S : SequenceType where S.Generator.Element == CoordinateTupleType.TupleType>(newElements: S) {
        
        var generator = newElements.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(tuple: coordinate, precision: self.precision))
        }
    }
    
    /**
     Append the elements of `newElements` to this LineString.
     */
    public mutating func appendContentsOf<C : CollectionType where C.Generator.Element == CoordinateTupleType.TupleType>(newElements: C) {
        
        var generator = newElements.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(CoordinateTupleType(tuple: coordinate, precision: self.precision))
        }
    }
    
    /**
     Append the elements of `newElements` to this LineString.
     */
    public mutating func appendContentsOf<S : SequenceType where S.Generator.Element == CoordinateTupleType>(newElements: S) {
        
        var generator = newElements.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(coordinate)
        }
    }
    
    /**
     Append the elements of `newElements` to this LineString.
     */
    public mutating func appendContentsOf<C : CollectionType where C.Generator.Element == CoordinateTupleType>(newElements: C) {
        
        var generator = newElements.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(coordinate)
        }
    }
    
    /**
     Remove an element from the end of this LineString.
     
     - Requires: `count > 0`.
     */
    public mutating func removeLast() -> CoordinateTupleType {
        return self.coordinates.removeLast()
    }
    
    /**
     Insert `newElement` at index `i` of this LineString.
     
     - Requires: `i <= count`.
     */
    public mutating func insert(newElement: CoordinateTupleType, atIndex i: Int) {
        self.coordinates.insert(newElement, atIndex: i)
    }
    
    /**
     Remove and return the element at index `i` of this LineString.
     */
    public mutating func removeAtIndex(index: Int) -> CoordinateTupleType {
        return self.coordinates.removeAtIndex(index)
    }
    
    /**
     Remove all elements of this LineString.
     
     - Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
     */
    public mutating func removeAll(keepCapacity keepCapacity: Bool = true) {
        self.coordinates.removeAll(keepCapacity: keepCapacity)
    }
}
extension LineString {
    public func pointN(index: Int) -> Point<CoordinateTupleType> {
        return Point<CoordinateTupleType>(coordinate: self[index], coordinateReferenceSystem: self.coordinateReferenceSystem, precision: self.precision)
    }
}
extension LineString : Geometry {
    
    public func isEmpty() -> Bool {
        return self.count == 0
    }
    
    public func equals(other: Geometry) -> Bool {
        if let other = other as? LineString {
            return self.elementsEqual(other, isEquivalent: { (lhs: CoordinateTupleType, rhs: CoordinateTupleType) -> Bool in
                return lhs == rhs
            })
        }
        return false
    }
}
extension LineString : Curve {
    
    /**
     The length of this LinearType calaculated using its associated CoordinateReferenceSystem.
     */
    @warn_unused_result
    public func length() -> Double {
        
        var length: Double  = 0.0
        
        var generator = self.generate()
        
        if var c1 = generator.next() {
            while let  c2 = generator.next() {
                var result = pow(abs(c1.x - c2.x), 2.0) + pow(abs(c1.y - c2.y), 2.0)
                
                if let c1 = c1 as? ThreeDimensional,
                   let c2 = c2 as? ThreeDimensional {
                        result += pow(abs(c1.z - c2.z), 2.0)
                }
                length += sqrt(result)
                c1 = c2
            }
        }
        return self.precision.convert(length)
    }
}

/*:

Usage Scenarios
*/

var lineString1 = LineString<Coordinate2D>()
lineString1.append((1.001, 1.001))
lineString1.append((2.001, 2.001))
lineString1.append((3.001, 3.001))

// lineString1.append((3.003, 3.003, 3.003))  // Error:

lineString1.length()

lineString1.pointN(0)

let fixedPrecision = FixedPrecision(scale: 100)

LineString<Coordinate2D>(coordinates: lineString1, precision: fixedPrecision)

var lineString2 = LineString<Coordinate2D>(coordinates: [(1.001, 1.001),(2.001, 2.001),(3.001, 3.001)], precision: fixedPrecision)

lineString2.length()
lineString1 == lineString2

lineString2.append(Coordinate2D(tuple: (4.001, 4.001), precision: FloatingPrecision()))
lineString2.append((5.001, 5.001))

var lineString3 = LineString<Coordinate3DM>()
lineString3.append((0.0, 0.0, 0.0, 0.0))
lineString3.append((0.0, 1.0, 0.0, 0.0))
lineString3.append((0.0, 2.0, 0.0, 0.0))
lineString3.append((0.0, 3.0, 0.0, 0.0))

lineString3.length()

let point3 = lineString3.pointN(2)
point3.x
point3.y
point3.z
point3.m

point3.coordinate

lineString1.pointN(0) == lineString1.pointN(0)
lineString1.pointN(1) == lineString1.pointN(1)

lineString1 == lineString1
lineString1 == lineString2
lineString1 == lineString3



