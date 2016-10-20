/*
 *   LinearRing+Geometry.swift
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

extension LinearRing : Geometry  {
    
    public
    var dimension: Dimension { return .one }
    
    
    public
    func isEmpty() -> Bool {
        return self.count == 0
    }
    
    /**
     - Returns: the closure of the combinatorial boundary of this Geometry instance.
     
     - Note: The boundary of a LineString if empty is the empty MultiPoint. If not empty it is the first and last point.
     */
    
    public
    func boundary() -> Geometry {
        
        return self.storage.withUnsafeMutablePointers { (count, elements) -> Geometry in
            
            var multiPoint = MultiPoint<CoordinateType>(precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem)
            
            if !self.isClosed() && count.pointee >= 2 {
                
                // Note: direct subscripts protected by self.count >= 2 above.
                multiPoint.append(Point<CoordinateType>(coordinate: elements[0], precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem))
                multiPoint.append(Point<CoordinateType>(coordinate: elements[count.pointee - 1], precision: self.precision, coordinateReferenceSystem: self.coordinateReferenceSystem))
                
            }
            return multiPoint
        }
    }
    
    
    public
    func equals(_ other: Geometry) -> Bool {
        if let other = other as? LinearRing<Element> {
            return self.elementsEqual(other, by: { (lhs: Element, rhs: Element) -> Bool in
                return lhs == rhs
            })
        }
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    
    public
    func union(_ other: Geometry) -> Geometry {
        return GeometryCollection()
    }
}
