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
public struct Coordinate3D : Coordinate, ThreeDimensional {
    
    public let x: Double
    public let y: Double
    public let z: Double

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Coordinate3D : _ArrayConstructable {
    
    public init(array: [Double]) {
        precondition(array.count == 3)
        
        self.init(x: array[0], y: array[1], z: array[2])
    }
}

extension Coordinate3D : CopyConstructable {
    
    public init(other: Coordinate3D) {
        self.init(x: other.x, y: other.y, z: other.z)
    }
    
    public init(other: Coordinate3D, precision: Precision) {
        self.init(x: precision.convert(other.x), y: precision.convert(other.y), z: precision.convert(other.z))
    }
}

extension Coordinate3D : TupleConvertable {
    
    public typealias TupleType = (x: Double, y: Double, z: Double)
    
    public var tuple: TupleType {
        get { return (x: self.x, y: self.y, z: self.z)  }
    }
    
    public init(tuple: TupleType) {
        self.init(x: tuple.x, y: tuple.y, z: tuple.z)
    }
    
    public init(tuple: TupleType, precision: Precision) {
        self.init(x: precision.convert(tuple.x), y: precision.convert(tuple.y), z: precision.convert(tuple.z))
    }
}

extension Coordinate3D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "(x: \(self.x), y: \(self.y), z: \(self.z))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}

extension Coordinate3D : Hashable {
    public var hashValue: Int {
        get {
            return 31 &* x.hashValue ^ 37 &* y.hashValue ^ 41 &* z.hashValue
        }
    }
}

public func ==(lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
