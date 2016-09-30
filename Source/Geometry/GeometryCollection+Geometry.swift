/*
 *   GeometryCollection+Geometry.swift
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

// MARK:  Geometry conformance

extension GeometryCollection : Geometry  {
    
    public var dimension: Dimension { get {
        
        return storage.withUnsafeMutablePointers { (count, elements)-> Dimension in
            
            var dimension: Dimension = .empty // No dimension
            
            if count.pointee > 0 {
                
                for index in 0..<count.pointee {
                    
                    dimension = Math.max(dimension, elements[index].dimension)
                }
            }
            return dimension
        }
        }
    }
    
    public func isEmpty() -> Bool {
        return self.count == 0
    }
    
    /**
     - Returns: the closure of the combinatorial boundary of this Geometry instance.
     */
    
    public
    func boundary() -> Geometry {
        // TODO: implement boundary
        return GeometryCollection()
    }
    
    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? GeometryCollection {
            return self.elementsEqual(other, by: { (lhs: Geometry, rhs: Geometry) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    public func union(_ other: Geometry) -> Geometry {
        return GeometryCollection()
    }
}
