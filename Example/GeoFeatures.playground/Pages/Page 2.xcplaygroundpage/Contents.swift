//: [Previous](@previous)

import Swift
import GeoFeatures2

/*:

Usage Scenarios
*/

var lineString1 = LineString<Coordinate2D>()
lineString1.append((1.001, 1.001))
lineString1.append((2.001, 2.001))
lineString1.append((3.001, 3.001))

// lineString1.append((3.003, 3.003, 3.003))  // Error:

lineString1.length()


let fixedPrecision = FixedPrecision(scale: 100)

let lineString = LineString<Coordinate2D>(coordinates: lineString1, precision: fixedPrecision)

var lineString2 = LineString<Coordinate2D>(coordinates: [(1.001, 1.001),(2.001, 2.001),(3.001, 3.001)], precision: fixedPrecision)

lineString == lineString2

lineString2.length()
lineString1 == lineString2

lineString2.append(Coordinate2D(tuple: (4.001, 4.001)))
lineString2.append((5.001, 5.001))

var lineString3 = LineString<Coordinate3DM>()
lineString3.append((0.0, 0.0, 0.0, 0.0))
lineString3.append((0.0, 1.0, 0.0, 0.0))
lineString3.append((0.0, 2.0, 0.0, 0.0))
lineString3.append((0.0, 3.0, 0.0, 0.0))

lineString3.length()

lineString1 == lineString1
lineString1 == lineString2
lineString1 == lineString3



