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
public struct Coordinate3D : Coordinate, ThreeDimensional, _CoordinateConstructable {
    public typealias TupleType = (x: Double, y: Double, z: Double)
    
    public var x: Double
    public var y: Double
    public var z: Double
    
    public var tuple: TupleType {
        get { return (self.x, self.y, self.z)  }
        set { self.x = newValue.x; self.y = newValue.y; self.z = newValue.z }
    }
    
    public init() {
        self.x = Double.NaN
        self.y = Double.NaN
        self.z = Double.NaN
    }
    
    public init(other: Coordinate3D) {
        self.x = other.x
        self.y = other.y
        self.z = other.z
    }
    
    public init(tuple: TupleType) {
        self.x = tuple.x
        self.y = tuple.y
        self.z = tuple.z
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
