//
//  Point+GeometryType.swift
//  Pods
//
//  Created by Tony Stone on 2/15/16.
//
//

import Swift

extension Point /* GeometryType Conformance */ {

    public func isEmpty() -> Bool {
        return false    // Point can never be empty
    }
    
    public func equals(other: GeometryType) -> Bool {
        if let other = other as? Point {
            if self.dimension == other.dimension {
                return self.x == other.x && self.x == other.y && other.dimension == 2 ? true : (self.z == other.z)
            }
        }
        return false
    }
    
    // TODO: Must be implenented.  Here just to test protocol
    public func union(other: GeometryType) -> GeometryType {
        return Point(coordinate: (0,0,0))
    }
}