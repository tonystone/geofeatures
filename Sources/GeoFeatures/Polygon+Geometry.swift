/*
 *   Polygon+Geometry.swift
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
 *   Created by Tony Stone on 2/15/16.
 */
import Swift

extension Polygon : Geometry  {

    public var dimension: Dimension { return .two }
    
    public func isEmpty() -> Bool {
        return self.outerRing.count == 0
    }

    /**
     - Returns: the closure of the combinatorial boundary of this Geometry instance.
     
     - Note: The boundary of a Polygon consists of a set of LinearRings that make up its exterior and interior boundaries
     */
    
    public
    func boundary() -> Geometry {
        
        var multiLineString = MultiLineString<CoordinateType>(precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem)
        
        if _outerRing.count > 0 {
            multiLineString.append(LineString<CoordinateType>(elements: _outerRing, precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem))
        
            for ring in _innerRings {
                multiLineString.append(LineString<CoordinateType>(elements: ring, precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem))
            }
        }
        return multiLineString
    }
    
    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? Polygon<CoordinateType> {
            return self.outerRing.equals(other.outerRing) && self.innerRings.elementsEqual(other.innerRings, by: { (lhs: LinearRing<CoordinateType>, rhs: LinearRing<CoordinateType>) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }

    // TODO: Must be implenented.  Here just to test protocol
    public func union(_ other: Geometry) -> Geometry {
        return Polygon()
    }
}

