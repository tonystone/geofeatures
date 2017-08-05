///
///  MultiPolygon+Geometry.swift
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

extension MultiPolygon: Geometry {

    public var dimension: Dimension { return .two }

    public func isEmpty() -> Bool {
        return self.count == 0
    }

    ///
    /// - Returns: the closure of the combinatorial boundary of this Geometry instance.
    ///
    /// - Note: The boundary of a MultiPolygon is a set of closed Curves (LineStrings) corresponding to the boundaries of its element Polygons. Each Curve in the boundary of the MultiPolygon is in the boundary of exactly 1 element Polygon, and every Curve in the boundary of an element Polygon is in the boundary of the MultiPolygon.
    ///
    public func boundary() -> Geometry {
        return self.buffer.withUnsafeMutablePointers({ (header, elements) -> Geometry in
            var multiLineString = MultiLineString<CoordinateType>(precision: self.precision, coordinateSystem: self.coordinateSystem)

            for i in 0..<header.pointee.count {

                if let boundary = elements[i].boundary() as? MultiLineString<CoordinateType> {

                    for lineString in boundary {
                        multiLineString.append(lineString)
                    }
                }
            }
            return multiLineString
        })
    }

    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? MultiPolygon<CoordinateType> {
            return self.elementsEqual(other, by: { (lhs: Polygon<CoordinateType>, rhs: Polygon<CoordinateType>) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }
}
