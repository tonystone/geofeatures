//
//  Polygon+Surface.swift
//  Pods
//
//  Created by Tony Stone on 2/15/16.
//
//

import Foundation

extension Polygon : Surface {

    /**
        Calculates the area of this `Polygon`
     
        - returns: The area of this `Polygon`.
     
        - requires: The "outerRing" be oriented clockwise
        - requires: The "innerRings" be oriented counter clockwise
        - requires: isSimple == true
        - requires: isClosed == true for "outerRing" and all "innerRings"
     */
    @warn_unused_result
    public func area() -> Double {
        
        var area: Double = _outerRing.area()
        
        var innerRings = _innerRings.generate()
        
        while let ring = innerRings.next() {
            area += ring.area()
        }
        return self.precision.convert(area)
    }

}