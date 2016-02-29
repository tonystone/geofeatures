//: [Previous](@previous)

import Foundation
import GeoFeatures2

Coordinate2D(tuple: (0.0,0.0)).hashValue
Coordinate2D(tuple: (1.0,0.0)).hashValue
Coordinate2D(tuple: (1.0,1.0)).hashValue
Coordinate2D(tuple: (2.0,0.0)).hashValue
Coordinate2D(tuple: (2.0,2.0)).hashValue
Coordinate2D(tuple: (3.0,0.0)).hashValue
Coordinate2D(tuple: (3.0,3.0)).hashValue
Coordinate2D(tuple: (4.0,0.0)).hashValue
Coordinate2D(tuple: (4.0,4.0)).hashValue
Coordinate2D(tuple: (5.0,0.0)).hashValue
Coordinate2D(tuple: (5.0,5.0)).hashValue


Coordinate2D(tuple: (5.0,5.00001)).hashValue
Coordinate2D(tuple: (5.0,5.000000000002)).hashValue