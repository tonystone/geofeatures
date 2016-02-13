
import Swift

/*:
## Coordinate System Types

These are used by the algorythms when they are applyed to the types
*/
public protocol CoordinateReferenceSystem {}

public struct Cartisian: CoordinateReferenceSystem {}

public struct Ellipsoidal: CoordinateReferenceSystem {}

public struct Spherical: CoordinateReferenceSystem {}

public struct Vertical: CoordinateReferenceSystem {}

public struct Polar: CoordinateReferenceSystem {}

//: ## Geometry types
/*:
GeometryType

A protocol that represents a geometric shape. GeometryType
is the abstract type that is implenented by all geometry classes.
 */
public protocol GeometryType {}

//: Generic Point type
public protocol PointType : GeometryType {}

//: Concrete types
public struct Point : PointType, GeometryType {
    
    public typealias CoordinateType = Double
    
    public var x: CoordinateType, y: CoordinateType
    
    /**
     * Initialize this Point with the x,y coordinates
     */
    public init(x: CoordinateType, y: CoordinateType) { self.x = x; self.y = y }
}

//public class Point3d : Point {
//    
//    public var z: CoordinateType
//    
//    /**
//     * Initialize this Point3d with the x,y,z coordinates
//     */
//    public init(x: CoordinateType, y: CoordinateType, z: CoordinateType) { self.z = z; super.init(x: x, y: y) }
//}

public class MultiPoint: Collection<PointType>, GeometryType  {}

public class LineString: Collection<PointType>, GeometryType {}

public class MultiLineString: Collection<LineString>, GeometryType {}

public class LinearRing: LineString {}

public class Polygon : GeometryType {
    
    public var outerRing: LinearRing
    public var innerRings: [LinearRing]
    
    public init(outerRing: LinearRing = LinearRing(), innerRings: [LinearRing] = []) { self.outerRing = outerRing; self.innerRings = innerRings }
}

public class MultiPolygon : Collection<Polygon>, GeometryType {}

public class GeometryCollection: Collection<GeometryType>, GeometryType {}

//: Geometry Type Operators
extension Point : Equatable {}

public func == (lhs: Point, rhs: Point) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }

/*: 
Generic Base Collection type that stores a collection of GeometryTypes.

It will be specialized for each type that implements it.
*/
public class Collection<Element /* : protocol<GeometryType, Equatable> */>  {
    
    public init () { elements = [Element]() }
    
    public convenience init<S : SequenceType where S.Generator.Element == Element>(elements: S) {
        self.init()
        
        var generator = elements.generate()
        
        while let element = generator.next() {
            self.elements.append(element)
        }
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == Element>(elements: C) {
        self.init()
        
        var generator = elements.generate()
        
        while let element = generator.next() {
            self.elements.append(element)
        }
    }
    private var elements: [Element]
}

extension Collection : CollectionType, MutableCollectionType,_DestructorSafeContainer {
    
    public var startIndex : Int { return elements.startIndex }
    public var endIndex   : Int { return elements.endIndex }
    
    public subscript(position : Int) -> Element {
        get         { return elements[position] }
        set (value) { elements[position] = value }
    }
    
    public func generate() -> IndexingGenerator<[Element]> {
        return elements.generate()
    }
}

extension Collection : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return elements.description }
    public var debugDescription : String { return elements.debugDescription }
}

//: Collection operators
@warn_unused_result
public func ==<T : CollectionType where T.Generator.Element == GeometryType>(lhs: T, rhs: T) -> Bool { return false }

@warn_unused_result
public func !=<T : CollectionType where T.Generator.Element == GeometryType>(lhs: T, rhs: T) -> Bool { return false }

@warn_unused_result
public func +=<T : CollectionType where T.Generator.Element == GeometryType>(lhs: T, rhs: T)  { }

@warn_unused_result
public func -=<T : CollectionType where T.Generator.Element == GeometryType>(lhs: T, rhs: T)  { }

/*: 
## Readers & Writers

Used to Read and Write from Various formats
*/
public protocol Writer {
    typealias ResultType
    static func write(string: String) -> ResultType?
}

public protocol Reader {
    typealias ResultType
    static func read(string: String) -> ResultType?
}

public struct WKTReader : Reader {
    public static func read(string: String) -> GeometryType? {
        return nil
    }
}

//: ## Algorythms
//: Query
/**
    - Returns: true if this geometric object is “spatially equal” to the other Geometry.
 */
public func ==(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns: true if this geometric object is “spatially disjoint” from the other Geometry.
 */
public func disjoint(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns: true if this geometric object “spatially intersects” the other Geometry.
 */
public func intersects(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns: true if this geometric object “spatially touches” the other Geometry.
 */
public func touches(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns: true if this geometric object “spatially crosses’ the other Geometry.
 */
public func crosses(geometry: GeometryType, other: GeometryType ) -> Bool { return false }
/**
    - Returns: true if this geometric object is “spatially within” the other Geometry.
 */
public func within(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns: true if this geometric object “spatially contains” the other Geometry
 */
public func contains(geometry: GeometryType, other: GeometryType ) -> Bool { return false }
/**
    - Returns: true if this geometric object “spatially overlaps” the other Geometry.
 */
public func overlaps(geometry: GeometryType, other: GeometryType ) -> Bool { return false }

/**
    - Returns true if this geometric object is spatially related to the other Geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.
    - Returns: false if all the tested intersections are empty except exterior (this) intersect exterior (another).
 */
public func relate(geometry: GeometryType, other: GeometryType, matrix :String) -> Bool { return false }

/**
    - Returns: A derived geometry collection value that matches the specified m coordinate value.
 */
public func locateAlong(geometry: GeometryType, mValue :Double) -> GeometryType { return GeometryCollection() }

/**
    - Returns: A derived geometry collection value that matches the specified range of m coordinate values inclusively.
 */
public func locateBetween(geometry: GeometryType, mStart :Double, mEnd :Double) -> GeometryType { return GeometryCollection() }

//: Analysis
//public func distance(geometry: GeometryType, other: GeometryType) -> Distance
//public func buffer(geometry: GeometryType, distance :Distance) : GeometryType
public func convexHull(geometry: GeometryType) -> GeometryType { return GeometryCollection() }
public func intersection(geometry: GeometryType, other: GeometryType) -> GeometryType { return GeometryCollection() }
public func union(geometry: GeometryType, other: GeometryType) -> GeometryType { return GeometryCollection() }
public func difference(geometry: GeometryType, other: GeometryType) -> GeometryType { return GeometryCollection() }
public func symDifference(geometry: GeometryType, other: GeometryType) -> GeometryType { return GeometryCollection() }


public func envelop(geometry: GeometryType) -> Polygon { return Polygon() }
public func isEmpty(geometry: GeometryType) -> Bool {

    switch geometry {
    case let polygon as Polygon:
        return polygon.outerRing.isEmpty
    case let multiPolygon as MultiPolygon:
        return multiPolygon.isEmpty
    default:
        return false
    }
}
public func isSimple(geometry: GeometryType) -> Bool { return true }
//: ## Usage scenarios
var geometryArray: [GeometryType] = [Point(x: 1, y: 1), Polygon()]

let geometryCollection1 = GeometryCollection(elements: geometryArray)
let geometryCollection2 = GeometryCollection()

if geometryCollection1 == geometryCollection2 {
    print(geometryCollection1)
}

//: Iterate over a collection type
for geometry in geometryCollection1 {
    print(geometry)
}

//: Assignment operators
geometryCollection1 += geometryCollection2
geometryCollection1 -= geometryCollection2

//: Comparison of points
let pointsEqual1 = Point(x: 1.4, y: 2.3) == Point(x: 1.4, y: 2.3)

let pointsEqual2 = Point(x: 1, y: 1) == Point(x: 1.4, y: 2.3)

//: Algorythms
let unionResult1 = union(Polygon(), other: Polygon())
let unionResult2 = union(Point(x: 1, y: 1), other: Point(x: 1, y: 1))
/*:
Readers and Writers
 */

if let polygonFromWkt = WKTReader.read("POLYGON((0 0,0 90,90 90,90 0,0 0))") as? Polygon {
    
    for point in polygonFromWkt.outerRing {
        print(point)
    }
}
