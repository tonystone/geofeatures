//
//  Polygon+Surface.swift
//  Pods
//
//  Created by Tony Stone on 2/15/16.
//
//

import Foundation

extension Polygon : Surface {

    @warn_unused_result
    public func area() -> Double {
        return 0
    }

    @warn_unused_result
    public func centroid() -> Point {
        return Point(coordinate: (0,0,0), precision: self.precision)
    }

    @warn_unused_result
    public func boundary() -> Geometry {
        return Polygon()
    }

}