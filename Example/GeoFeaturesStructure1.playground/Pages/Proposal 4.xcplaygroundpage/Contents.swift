//: [Previous](@previous)

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


public struct Point<CT : protocol<Equatable, Comparable>, CRS: CoordinateReferenceSystem> : PointType, GeometryType {
    
    public typealias CoordinateType = CT
    public typealias CoordinateReferenceSystem = Cartisian
    
    init(x: CoordinateType, y: CoordinateType) {
        coordinates.reserveCapacity(Point.dimensions)
        
        coordinates[0] = x
        coordinates[1] = y
    }
    
    public func get(dimension: Int) -> CoordinateType {
        assert(dimension < self.dynamicType.dimensions)
        
        return coordinates[dimension]
    }
    public mutating func set(dimension: Int, value: CoordinateType) {
        assert(dimension < self.dynamicType.dimensions)
        
        coordinates[dimension] = value
    }
    public static var dimensions: Int { get { return 2 } }
    private var coordinates = ContiguousArray<CoordinateType>()
}

public protocol GeometryCollectionType : CollectionType, GeometryType {
}

public struct GeometryCollection<Element where Element : GeometryType> : GeometryCollectionType {
    
    public var startIndex : Int { return elements.startIndex }
    public var endIndex   : Int { return elements.endIndex }
    
    public subscript(position : Int) -> Element {
        get         { return elements[position] }
        set (value) { elements[position] = value }
    }
    
    public func generate() -> IndexingGenerator<ContiguousArray<Element>> {
        return elements.generate()
    }
    private var elements = ContiguousArray<Element>()
}


public struct MultiPoint<Element where Element : PointType> : GeometryCollectionType {
    
    public var startIndex : Int { return elements.startIndex }
    public var endIndex   : Int { return elements.endIndex }
    
    public subscript(position : Int) -> Element {
        get         { return elements[position] }
        set (value) { elements[position] = value }
    }
    
    public func generate() -> IndexingGenerator<ContiguousArray<Element>> {
        return elements.generate()
    }
    private var elements = ContiguousArray<Element>()
}

//let geometryCollection = GeometryCollection<GeometryType>()

var multiPoint = MultiPoint<Point<Double,Cartisian>>()

multiPoint[0] = Point<Double,Cartisian>(x: 1, y: 1)

print(multiPoint)

