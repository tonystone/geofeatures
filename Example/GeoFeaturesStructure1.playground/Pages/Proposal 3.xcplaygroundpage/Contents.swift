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
var geometryArray = [Point(coordinate: (1,1)), Polygon()]
var pointArray: [Point]  = [Point(coordinate: (1,1)), Point(coordinate: (2,2))]

var geometryCollection1 = GeometryCollection<Geometry>(elements: geometryArray)
var geometryCollection2 = GeometryCollection<Geometry>(elements: pointArray as [Geometry])

//let multiPoint = MultiPoint(pointArray)

// Comparison of Geometry type arrays
let arraysMatch = [Point(coordinate: (1,1)), Polygon()] == [Point(coordinate: (1,1)), Polygon()]

//  Iterate over a collection type
for geometry in geometryCollection1 {
    print(geometry)
}

let pointIsEmpty               = Point(coordinate: (1,1)).isEmpty()
let polygon1IsEmpty            = Polygon().isEmpty()
let polygon2IsEmpty            = Polygon(rings: ([(0,0), (0,7), (4,2), (2,0), (0,0)],[])).isEmpty()
let lineString1IsEmpty         = LineString().isEmpty()
let lineString2IsEmpty         = LineString(coordinates:[(0,0,0), (0,7,0), (4,2,0), (2,0,0), (0,0,0)]).isEmpty()

let geometryCollection1IsEmpty = GeometryCollection<Geometry>().isEmpty()
let geometryCollection2IsEmpty = GeometryCollection<Geometry>(elements: [Point(coordinate: (1,1))]).isEmpty()

// Comparison of points
let pointsMatch1 = Point(coordinate: (1.4, 2.3)) == Point(coordinate: (1.4, 2.3))

let pointsMatch2 = Point(coordinate: (1, 1)) == Point(coordinate: (1.4, 2.3))

//: Algorythms
let unionResult1 = Polygon().union(Polygon())
let unionResult2 = Point(coordinate: (1, 1)).union(Point(coordinate: (1, 1)))


/**
Readers and Writers
*/

if let polygonFromWkt = WKTReader<Polygon>.read("POLYGON((0 0,0 90,90 90,90 0,0 0))")  {
    for coordinate in polygonFromWkt.outerRing {
        print(coordinate)
    }
}

if let geometryFromWkt = WKTReader<Geometry>.read("POLYGON((0 0,0 90,90 90,90 0,0 0))")  {
    print(geometryFromWkt)
}
