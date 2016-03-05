//: [Previous](@previous)

import Swift
import Foundation
import GeoFeatures2

do {
    
    let point = try WKTReader<Coordinate2D>.read("point(1.0 1.0)")
    
    try WKTReader<Coordinate2D>.read("LINESTRING(1.0 1.0, 2.0 2.0, 3.0 3.0)")
    
} catch {
    error
}




