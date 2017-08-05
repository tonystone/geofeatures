///
///  Coordinate2D.swift
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
///  Created by Tony Stone on 2/9/2016.
///
import Swift

///
/// 2D Coordinate
///
/// Low level 2 dimensional Coordinate type
///
public struct Coordinate2D: Coordinate {

    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Coordinate2D: _ArrayConstructable {

    public init(array: [Double]) {
        precondition(array.count == 2)

        self.init(x: array[0], y: array[1])
    }
}

extension Coordinate2D: CopyConstructable {

    public init(other: Coordinate2D) {
        self.init(x: other.x, y: other.y)
    }

    public init(other: Coordinate2D, precision: Precision) {
        self.init(x: precision.convert(other.x), y: precision.convert(other.y))
    }
}

extension Coordinate2D: TupleConvertible {

    public typealias TupleType = (x: Double, y: Double)

    public var tuple: TupleType {
        return (x: self.x, y: self.y)
    }

    public init(tuple: TupleType) {
        self.init(x: tuple.x, y: tuple.y)
    }

    public init(tuple: TupleType, precision: Precision) {
        self.init(x: precision.convert(tuple.x), y: precision.convert(tuple.y))
    }
}

extension Coordinate2D: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "(x: \(self.x), y: \(self.y))"
    }

    public var debugDescription: String {
        return self.description
    }
}

extension Coordinate2D: Hashable {

    public var hashValue: Int {
        return 31 &* x.hashValue ^ 37 &* y.hashValue
    }
}

public func == (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
