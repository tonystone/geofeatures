//
//  Point+Geometry.swift
//  Pods
//
//  Created by Tony Stone on 2/15/16.
//
//

import Swift

extension Point : Geometry {

    public func isEmpty() -> Bool {
        return false    // Point can never be empty
    }
    
    public func equals(other: Geometry) -> Bool {
        if let other = other as? Point {
            return self.coordinate == other.coordinate
        }
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    public func union(other: Geometry) -> Geometry {
        return GeometryCollection()
    }
}
