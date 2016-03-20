/*
 *   Coordinate3D.swift
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
    3D Coordinate
 
    Low level 3 dimensional Coorodinate type
 */
public class Coordinate3D : Coordinate, ThreeDimensional, TupleConvertable {
    
    public typealias TupleType = (x: Double, y: Double, z: Double)
    
    public let x: Double
    public let y: Double
    public let z: Double

    public var tuple: TupleType {
        get { return (x: self.x, y: self.y, z: self.z)  }
    }
    
    public required init(tuple: TupleType) {
        self.x = tuple.x
        self.y = tuple.y
        self.z = tuple.z
    }

    public required init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
        self.z = precision.convert(tuple.z)
    }
    
    public required init(coordinate: Coordinate3D) {
        self.x = coordinate.x
        self.y = coordinate.y
        self.z = coordinate.z
    }
    
    public required init(coordinate: Coordinate3D, precision: Precision) {
        self.x = precision.convert(coordinate.x)
        self.y = precision.convert(coordinate.y)
        self.z = precision.convert(coordinate.z)
    }
    
    public required init(array: [Double]) {
        precondition(array.count == 3)
        self.x = array[0]
        self.y = array[1]
        self.z = array[2]
    }
    
}

public func ==(lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

extension Coordinate3D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "(x: \(self.x), y: \(self.y), z: \(self.z))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}
