///
///  Coordinate3DM.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 2/21/2016.
///
import Swift

///
/// Measured 3D Coordinate
///
/// Low level 3 dimensional Coordinate type with an m value.
///
public struct Coordinate3DM: Coordinate, ThreeDimensional, Measured {

    public let x: Double
    public let y: Double
    public let z: Double
    public let m: Double

    public init(x: Double, y: Double, z: Double, m: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.m = m
    }
}

extension Coordinate3DM: _ArrayConstructable {

    public init(array: [Double]) {
        precondition(array.count == 4)

        self.init(x: array[0], y: array[1], z: array[2], m: array[3])
    }
}

extension Coordinate3DM: CopyConstructable {

    public init(other: Coordinate3DM) {
        self.init(x: other.x, y: other.y, z: other.z, m: other.m)
    }

    public init(other: Coordinate3DM, precision: Precision) {
        self.init(x: precision.convert(other.x), y: precision.convert(other.y), z: precision.convert(other.z), m: precision.convert(other.m))
    }
}

extension Coordinate3DM: TupleConvertible {

    public typealias TupleType = (x: Double, y: Double, z: Double, m: Double)

    public var tuple: TupleType {
        return (x: self.x, y: self.y, z: self.z, m: self.m)
    }

    public init(tuple: TupleType) {
        self.init(x: tuple.x, y: tuple.y, z: tuple.z, m: tuple.m)
    }

    public init(tuple: TupleType, precision: Precision) {
        self.init(x: precision.convert(tuple.x), y: precision.convert(tuple.y), z: precision.convert(tuple.z), m: precision.convert(tuple.m))
    }
}

extension Coordinate3DM: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "(x: \(self.x), y: \(self.y), z: \(self.z), m: \(self.m))"
    }

    public var debugDescription: String {
        return self.description
    }
}

extension Coordinate3DM: Hashable {

    public var hashValue: Int {
        return 31 &* x.hashValue ^ 37 &* y.hashValue ^ 41 &* z.hashValue ^ 53 &* m.hashValue
    }
}

public func == (lhs: Coordinate3DM, rhs: Coordinate3DM) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.m == rhs.m
}
