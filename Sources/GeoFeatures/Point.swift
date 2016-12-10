///
///  Point.swift
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
/// Point
///
/// A Point is a 0-dimensional geometric object and represents a single location in coordinate space. A Point has an
/// x coordinate value, a y coordinate value. If called for by the associated Spatial Reference System, it may also
/// have coordinate values for z.
///
public struct Point<CoordinateType: Coordinate & CopyConstructable> {

    public let precision: Precision
    public let coordinateSystem: CoordinateSystem

    public var x: Double {
        return coordinate.x
    }
    public var y: Double {
        return coordinate.y
    }

    ///
    /// Constructs a Point with another Point of the same type.
    ///
    public init(other: Point<CoordinateType>, precision: Precision = defaultPrecision, coordinateSystem: CoordinateSystem = defaultCoordinateSystem) {

        self.precision = precision
        self.coordinateSystem = coordinateSystem

        self.coordinate = CoordinateType(other: other.coordinate, precision: precision)
    }

    ///
    /// Constructs a Point with a Coordinate of type CoordinateType.
    ///
    public init(coordinate: CoordinateType, precision: Precision = defaultPrecision, coordinateSystem: CoordinateSystem = defaultCoordinateSystem) {

        self.precision = precision
        self.coordinateSystem = coordinateSystem

        self.coordinate = CoordinateType(other: coordinate, precision: precision)
    }

    internal let coordinate: CoordinateType
}

extension Point where CoordinateType: ThreeDimensional {
    public var z: Double {
        return coordinate.z
    }
}

extension Point where CoordinateType: Measured {
    public var m: Double {
        return coordinate.m
    }
}

extension Point where CoordinateType: TupleConvertible {

    public init(coordinate: CoordinateType.TupleType, precision: Precision = defaultPrecision, coordinateSystem: CoordinateSystem = defaultCoordinateSystem) {
        self.init(coordinate: CoordinateType(tuple: coordinate, precision: precision))
    }
}

extension Point: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "\(type(of: self))\(self.coordinate)"
    }

    public var debugDescription: String {
        return self.description
    }
}

extension Point: Equatable {}

public func == <CoordinateType: Coordinate & CopyConstructable>(lhs: Point<CoordinateType>, rhs: Point<CoordinateType>) -> Bool {
    return lhs.equals(rhs)
}
