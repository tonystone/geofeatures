//
//  MultiPolygon+Surface.swift
//  Pods
//
//  Created by Tony Stone on 3/29/16.
//
//

import Swift

extension MultiPolygon : Surface {
    
    @warn_unused_result
    public func area() -> Double {
        
        return storage.withUnsafeMutablePointers { (count, elements)->Double in
            
            var area: Double = 0.0
            
            if count.memory > 0 {
                
                for index in 0..<count.memory {
                    area += elements[index].area()
                }
            }
            return self.precision.convert(area)
        }
    }
}
