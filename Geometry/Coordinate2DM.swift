/*
 *   Coordinate2DM.swift
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
 *   Created by Tony Stone on 2/21/16.
 */
import Swift

/**
    Measuted 2D Coordinate
 
    Low level 2 dimensional Coorodinate type with an m value.
 */
public struct Coordinate2DM : Coordinate, Measured, TupleConvertable  {
    
    public typealias TupleType = (x: Double, y: Double, m: Double)
    
    public var x: Double
    public var y: Double
    public var m: Double
    
    public init() {
        self.x = Double.NaN
        self.y = Double.NaN
        self.m = Double.NaN
    }
    
    public var tuple: TupleType {
        get { return (self.x, self.y, self.m)  }
        set { self.x = newValue.x; self.y = newValue.y; self.m = newValue.m }
    }

    public init(tuple: TupleType) {
        self.x = tuple.x
        self.y = tuple.y
        self.m = tuple.m
    }
}

extension Coordinate2DM : Equatable, Hashable {
    public var hashValue: Int { get { return x.hashValue ^ y.hashValue ^ m.hashValue } }
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
