
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

/**
 Generic Point type
 */
public protocol PointType : GeometryType, Equatable {
    
    typealias CoordinateType
    typealias CoordinateReferenceSystem
    
    static var dimensions: Int { get }
    
    @warn_unused_result
    func get(dimension: Int) -> CoordinateType
    mutating func set(dimension: Int, value: CoordinateType)
}

public func ==<T where T: PointType, T.CoordinateType: Comparable>(geometry: T, other: T) -> Bool {
    for dimension in 0...T.dimensions {
        if geometry.get(dimension) != other.get(dimension) {
            return false
        }
    }
    return true
}

public class MultiPoint: Collection<PointType>, GeometryType {}

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

//: ## Usage

public class Point : PointType, GeometryType {
    
    public typealias CoordinateType = Double
    public typealias CoordinateReferenceSystem = Cartisian
    
    init(x: CoordinateType, y: CoordinateType) {
        coordinates[0] = x
        coordinates[1] = y
    }
    
    public func get(dimension: Int) -> CoordinateType {
        return coordinates[dimension]
    }
    public func set(dimension: Int, value: CoordinateType) {
        coordinates[dimension] = value
    }
    public class var dimensions: Int { get { return 2 } }
    private var coordinates = [CoordinateType]()
}



