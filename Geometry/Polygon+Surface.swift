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
    public func centroid() -> Geometry {
        return GeometryCollection()
    }

    @warn_unused_result
    public func boundary() -> Geometry {
        return Polygon<CoordinateType>()
    }

}