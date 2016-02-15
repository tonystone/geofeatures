/*
 *   Point.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 2/9/16.
 */
import Swift

/**
 Point
 
 A Point is a 0-dimensional geometric object and represents a single location in coordinate space. A Point has an
 x coordinate value, a y coordinate value. If called for by the associated Spatial Reference System, it may also
 have coordinate values for z.
 */
public struct Point : LinearType {
    
    public let dimension: Int
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem
    
    private let coordinate: Coordinate3D
    
    /**
     * Initialize this Point with the coordinates
     */
    public init(coordinate: (Double, Double), precision: Precision = defaultPrecision) {
        self.dimension = 2
        self.precision = precision
        
        self.coordinate = precision.convert((coordinate.0, coordinate.1, Double.NaN))
    }
    
    public init(coordinate: (Double, Double, Double), precision: Precision = defaultPrecision)  {
        self.dimension = 3
        self.precision = precision
        
        self.coordinate = precision.convert(coordinate)
    }

    public var x: Double { get { return coordinate.x } }
    public var y: Double { get { return coordinate.y } }
    public var z: Double { get { return coordinate.z } }
}

extension Point : GeometryType {
    
    public func isEmpty() -> Bool {
        return false    // Point can never be empty
    }
    
    public func equals(other: GeometryType) -> Bool {
        if let other = other as? Point {
            return self.coordinate == other.coordinate
        }
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    public func union(other: GeometryType) -> GeometryType {
        return Point(coordinate: (0,0,0))
    }
}

extension Point : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "\(self.dynamicType)(\(self.coordinate.0),\(self.coordinate.1),\(self.coordinate.2))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}





