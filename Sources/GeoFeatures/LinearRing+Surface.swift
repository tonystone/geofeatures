/*
 *   LinearRing+Surfcae.swift
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
 *   Created by Tony Stone on 3/28/16.
 */
import Swift

/**
    Surface extension for LinearRing
 */
extension LinearRing : Surface {
    
    /**
        Calculates the area of this `LinearRing`
        
        - returns: The area of this `LinearRing`. If the orientation of the ring is clockwise, area will be postive, otherwise it will be negative.
     
        - requires: isSimple == true
        - requires: isClosed == true
     */
    
    public func area() -> Double {
        
        return storage.withUnsafeMutablePointers { (count, elements)->Double in
            
            var area: Double = 0.0
            
            if count.pointee > 0 {
                
                var c1 = elements[0]
                
                for index in 1..<count.pointee {
                    
                    let c2 = elements[index]
                    
                    let height = (c1.y + c2.y) / 2
                    let width  = c2.x - c1.x
                    
                    area += width * height
                    
                    c1 = c2
                }
            }
            return self.precision.convert(area)
        }
    }
    
}
