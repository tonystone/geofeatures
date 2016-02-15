import Swift
import GeoFeatures2

//: ## Usage scenarios
// Simple Array of tubles used as coordinates
let coordinates2d: [(Double, Double)]         = [(0,0), (0,7), (4,2), (2,0), (0,0)]
let coordinates3d: [(Double, Double, Double)] = [(0,0,0), (0,7,0), (4,2,0), (2,0,0), (0,0,0)]

// LinearRing created with simple tuble array
let ring2d = LinearRing(coordinates: coordinates2d)

let ring3d = LinearRing(coordinates:coordinates3d)

// LineString
let lineString1 = LineString(coordinates:[(0,0,0), (0,7,0), (4,2,0), (2,0,0), (0,0,0)])

// Create a Polygon with a simple array of tuples and an array of innerRings
let polygon1 = Polygon(outerRing: [(0,0), (0,7), (4,2), (2,0), (0,0)], innerRings: [])

// Create a Polygon with a tuple simaler to WKT with the syntax ([tuples], [[tuples]])
let polygon2 = Polygon(rings: ([(0,0), (0,7), (4,2), (2,0), (0,0)],[]))
let polygon3 = Polygon(rings: ([(0,0), (0,7), (4,2), (2,0), (0,0)],[[(0.5,0.5), (0.5,6.5), (3.5,1.5), (1.5,0.5), (0.5,0.5)]]))

// Geoemetry arrays can be constructed and used to create rthe collection types
var geometryArray: [GeometryType] = [Point(coordinate: (1,1)), Polygon()]
var pointArray:    [GeometryType] = [Point(coordinate: (1,1)), Point(coordinate: (2,2))]

var geometryCollection1 = GeometryCollection(elements: geometryArray)
var geometryCollection2 = GeometryCollection(elements: pointArray)

//let multiPoint = MultiPoint(pointArray)

//  Iterate over a collection type
for geometry in geometryCollection1 {
    print(geometry)
}

let pointIsEmpty               = Point(coordinate: (1,1)).isEmpty()
let polygon1IsEmpty            = Polygon().isEmpty()
let polygon2IsEmpty            = Polygon(rings: ([(0,0), (0,7), (4,2), (2,0), (0,0)],[])).isEmpty()
let lineString1IsEmpty         = LineString().isEmpty()
let lineString2IsEmpty         = LineString(coordinates:[(0,0,0), (0,7,0), (4,2,0), (2,0,0), (0,0,0)]).isEmpty()

let geometryCollection1IsEmpty = GeometryCollection().isEmpty()
let geometryCollection2IsEmpty = GeometryCollection(elements: [Point(coordinate: (1,1))] as [GeometryType]).isEmpty()

// Comparison of points
let pointsMatch1 = Point(coordinate: (1.4, 2.3)) == Point(coordinate: (1.4, 2.3))

let pointsMatch2 = Point(coordinate: (1, 1)) == Point(coordinate: (1.4, 2.3))

//: Algorythms
let unionResult1 = Polygon().union(Polygon())
let unionResult2 = Point(coordinate: (1, 1)).union(Point(coordinate: (1, 1)))

if let linearType = LineString() as? protocol<GeometryType, LinearType> {
    print(linearType.dimension)
} else {
    print("Can't convert")
}

/**
Readers and Writers
*/

do {
    let polygonFromWkt = try WKTReader.read("POLYGON((0 0,0 90,90 90,90 0,0 0))")
    
    print(polygonFromWkt)
} catch {
   print(error)
}


