/*
 *   Geometry.swift
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
    Default Precision for all class
 */
let defaultPrecision = FloatingPrecision()

/**
    Default CoordinateReferenceSystem
 */
let defaultCoordinateReferenceSystem = Cartisian()

/**
 Geometry
 
 Base class for all GeometryTypes
 */
public class Geometry  : GeometryType {
    
    public let dimension: Int
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem

    internal convenience init() {
        self.init(dimension: 0, precision: defaultPrecision)
    }
    internal init(dimension: Int, precision: Precision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) {
        self.dimension = dimension
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
    }
    
    public func isEmpty() -> Bool {
        return true
    }
    
    public func equals(other: GeometryType) -> Bool {
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    public func union(other: GeometryType) -> GeometryType {
        return Point(coordinate: (0,0,0))
    }

}
