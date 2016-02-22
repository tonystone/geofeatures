//
//  Coordinate2DM.swift
//  Pods
//
//  Created by Tony Stone on 2/21/16.
//
//

import Swift

/**
    Measuted 2D Coordinate
 
    Low level 2 dimensional Coorodinate type with an m value.
 */
public struct Coordinate2DM : Coordinate, Measured, _CoordinateConstructable  {
    public typealias TupleType = (x: Double, y: Double, m: Double)
    
    public var x: Double
    public var y: Double
    public var m: Double
    
    public var tuple: TupleType {
        get { return (self.x, self.y, self.m)  }
        set { self.x = newValue.x; self.y = newValue.y; self.m = newValue.m }
    }
    
    public init() {
        self.x = Double.NaN
        self.y = Double.NaN
        self.m = Double.NaN
    }
    
    public init(other: Coordinate2DM) {
        self.x = other.x
        self.y = other.y
        self.m = other.m
    }
    
    public init(tuple: TupleType) {
        self.x = tuple.x
        self.y = tuple.y
        self.m = tuple.m
    }
}

public func ==(lhs: Coordinate2DM, rhs: Coordinate2DM) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.m == rhs.m
}

extension Coordinate2DM : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "(x: \(self.x), y: \(self.y), m: \(self.m))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}
