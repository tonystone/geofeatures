///
///  Polygon+Geometry.swift
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
///  Created by Tony Stone on 2/15/2016.
///
import Swift

extension Polygon: Geometry {

    public var dimension: Dimension { return .two }

    public func isEmpty() -> Bool {
        return self.outerRing.count == 0
    }

    ///
    /// - Returns: the closure of the combinatorial boundary of this Geometry instance.
    ///
    /// - Note: The boundary of a Polygon consists of a set of LinearRings that make up its exterior and interior boundaries
    ///
    public func boundary() -> Geometry {

        return buffer.withUnsafeMutablePointers { (header, elements) -> MultiLineString<CoordinateType> in

            var multiLineString = MultiLineString<CoordinateType>(precision: self.precision, coordinateSystem: self.coordinateSystem)

            for i in 0..<header.pointee.count {
                multiLineString.append(LineString<CoordinateType>(elements: elements[i], precision: self.precision, coordinateSystem: self.coordinateSystem))
            }
            return multiLineString
        }
    }

    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? Polygon<CoordinateType> {
            return self.outerRing.equals(other.outerRing) && self.innerRings.elementsEqual(other.innerRings, by: { (lhs: LinearRing<CoordinateType>, rhs: LinearRing<CoordinateType>) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }
}
