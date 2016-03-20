/*
 *   Coordinate2D.swift
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
 *   Created by Tony Stone on 2/9/16.
 */
import Swift

/**
    2D Coordinate
 
    Low level 2 dimensional Coorodinate type
 */
public class Coordinate2D : Coordinate, TupleConvertable {
    
    public typealias TupleType = (x: Double, y: Double)
    
    public let x: Double
    public let y: Double
    
    public var tuple: TupleType {
        get { return (x: self.x, y: self.y) }
    }
    
    public required init(tuple: TupleType) {
        self.x = tuple.x
        self.y = tuple.y
    }
    
    public required init(tuple: TupleType, precision: Precision) {
        self.x = precision.convert(tuple.x)
        self.y = precision.convert(tuple.y)
    }
    
    public required init(coordinate: Coordinate2D) {
        self.x = coordinate.x
        self.y = coordinate.y
    }
    
    public required init(coordinate: Coordinate2D, precision: Precision) {
        self.x = precision.convert(coordinate.x)
        self.y = precision.convert(coordinate.y)
    }
    
    public required init(array: [Double]) {
        precondition(array.count == 2)
        self.x = array[0]
        self.y = array[1]
    }
}

public func ==(lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Coordinate2D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "(x: \(self.x), y: \(self.y))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}

