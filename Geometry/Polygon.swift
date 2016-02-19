/*
 *   Polygon.swift
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
 Polygon
 */
public struct Polygon : Geometry {
    
    public typealias RingType = LinearRing
    
    public let dimension: Int
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem

    public var outerRing:  RingType   { get { return _outerRing } }
    public var innerRings: [RingType] { get { return _innerRings } }

    private var _outerRing = RingType()
    private var _innerRings = [RingType]()

    public init () {
        self.dimension = 0
        self.precision = defaultPrecision
    }
    
    public  init<C : CollectionType where C.Generator.Element == (Double, Double), C.Index.Distance == Int>(rings: (C,[C]), precision: Precision = defaultPrecision) {
        self.init(outerRing: rings.0, innerRings: rings.1, precision: precision)
    }
    
    public  init<C : CollectionType where C.Generator.Element == (Double, Double), C.Index.Distance == Int>(outerRing: C, innerRings: [C], precision: Precision = defaultPrecision) {
        self.dimension = 2
        self.precision = defaultPrecision
        
        var outerRingsGenerator = outerRing.generate()
        
        while let (x, y) = outerRingsGenerator.next() {
            self._outerRing.append(precision.convert((x,y,Double.NaN)))
        }
        self._innerRings.reserveCapacity(innerRings.count)
        
        var innerRingsGenerator = innerRings.generate()
        
        while let ring = innerRingsGenerator.next() {
            self._innerRings.append(RingType(coordinates: ring, precision: precision))
        }
    }
    
    public  init<C : CollectionType where C.Generator.Element == (Double, Double, Double), C.Index.Distance == Int>(rings: (C,[C]), precision: Precision = defaultPrecision) {
        self.init(outerRing: rings.0, innerRings: rings.1, precision: precision)
    }
    
    public  init<C : CollectionType where C.Generator.Element == (Double, Double, Double), C.Index.Distance == Int>(outerRing: C, innerRings: [C], precision: Precision = defaultPrecision) {
        self.dimension = 3
        self.precision = defaultPrecision
        
        var outerRingsGenerator = outerRing.generate()
        
        while let coordinate = outerRingsGenerator.next() {
            self._outerRing.append(precision.convert(coordinate))
        }
        self._innerRings.reserveCapacity(innerRings.count)
        
        var innerRingsGenerator = innerRings.generate()
        
        while let ring = innerRingsGenerator.next() {
            self._innerRings.append(RingType(coordinates: ring, precision: precision))
        }
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible Conformance

extension Polygon : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        
        let innerRingsDescription = { () -> String in
            var string: String = ""
            
            var innerRingsGenerator = self.innerRings.generate()
            
            while let ring = innerRingsGenerator.next() {
                if string.characters.count > 0  { string += "," }
                string += ring.description
            }
            
            if string.characters.count == 0 { string += "[]" }
            return string
        }
        return "\(self.dynamicType)(\(self.outerRing.description),\(innerRingsDescription()))"
    }
    
    public var debugDescription : String {
        return  self.description
    }
}
