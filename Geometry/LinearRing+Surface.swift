//
//  LinearRing+Surface.swift
//  Pods
//
//  Created by Tony Stone on 3/28/16.
//
//

import Swift

/**
    Surface extension for LinearRing
 */
extension LinearRing : Surface {
    
    /**
        Calculates the area of this `LinearRing`
        
        - returns: The area of this `LinearRing`. If the orientation of the ring is clockwise, are will be postive, otherwise it will be negative.
     
        - requires: isSimple == true
        - requires: isClosed == true
     */
    @warn_unused_result
    public func area() -> Double {
        
        return storage.withUnsafeMutablePointers { (count, elements)->Double in
            
            var area: Double = 0.0
            
            if count.memory > 0 {
                
                var c1 = elements[0]
                
                for index in 1..<count.memory {
                    
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
