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
public class Polygon : Geometry {
    
    public typealias RingType = LinearRing
    
    public var outerRing:  RingType   { get { return _outerRing } }
    public var innerRings: [RingType] { get { return _innerRings } }
    
    public convenience init() {
        self.init(dimension: 0, precision: defaultPrecision)
    }
    
    internal init(dimension: Int, precision: Precision) {
        super.init(dimension: dimension, precision: precision)
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double), C.Index.Distance == Int>(rings: (C,[C]), precision: Precision = defaultPrecision) {
        self.init(outerRing: rings.0, innerRings: rings.1, precision: precision)
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double), C.Index.Distance == Int>(outerRing: C, innerRings: [C], precision: Precision = defaultPrecision) {
        self.init(dimension: 2, precision: precision)
        
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
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double, Double), C.Index.Distance == Int>(rings: (C,[C]), precision: Precision = defaultPrecision) {
        self.init(outerRing: rings.0, innerRings: rings.1, precision: precision)
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double, Double), C.Index.Distance == Int>(outerRing: C, innerRings: [C], precision: Precision = defaultPrecision) {
        self.init(dimension: 2, precision: precision)
        
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
    
    public override func isEmpty() -> Bool {
        return self._outerRing.count == 0
    }
    
    public override func equals(other: GeometryType) -> Bool {
        if let other = other as? Polygon {
            return self._outerRing.equals(other._outerRing) && self._innerRings.elementsEqual(other._innerRings, isEquivalent: { (lhs: LinearRing, rhs: LinearRing) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }
    
    private var _outerRing = RingType()
    private var _innerRings = [RingType]()
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
