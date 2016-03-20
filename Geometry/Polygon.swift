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
public struct Polygon<CoordinateType : protocol<Coordinate, TupleConvertable>> : Geometry {
    
    public typealias RingType = LinearRing<CoordinateType>
    
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem

    public var outerRing:  RingType   { get { return _outerRing } }
    public var innerRings: [RingType] { get { return _innerRings } }

    private var _outerRing = RingType()
    private var _innerRings = [RingType]()

    public init (coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        self.coordinateReferenceSystem = coordinateReferenceSystem
        self.precision = precision
    }
    
    public  init<C : CollectionType where C.Generator.Element == CoordinateType, C.Index.Distance == Int>(outerRing: C, innerRings: [C], coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
       
        self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: precision)
        
        var outerRingsGenerator = outerRing.generate()
        
        self._outerRing.reserveCapacity(outerRing.count)
        
        while let coordinate = outerRingsGenerator.next() {
            
            self._outerRing.append(CoordinateType(other: coordinate, precision: precision))
        }
        self._innerRings.reserveCapacity(innerRings.count)
        
        var innerRingsGenerator = innerRings.generate()
        
        while let ring = innerRingsGenerator.next() {
            self._innerRings.append(RingType(elements: ring, precision: precision))
        }
    }
    
}

extension Polygon where CoordinateType : TupleConvertable {
    
    public  init<C : CollectionType where C.Generator.Element == CoordinateType.TupleType, C.Index.Distance == Int>(rings: (C,[C]), coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
       self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: precision)
        
        var outerRingsGenerator = rings.0.generate()
        
        self._outerRing.reserveCapacity(outerRing.count)
        
        while let coordinate = outerRingsGenerator.next() {

            self._outerRing.append(CoordinateType(tuple: coordinate, precision: precision))
        }
        self._innerRings.reserveCapacity(innerRings.count)
        
        var innerRingsGenerator = rings.1.generate()
        
        while let ring = innerRingsGenerator.next() {
            self._innerRings.append(RingType(elements: ring, precision: precision))
        }
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible Conformance

extension Polygon : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        
        let outerRingDescription = { () -> String in
            var string: String = ""
            
            var ringGenerator = self.outerRing.generate()
            
            while let coordinate = ringGenerator.next() {
                if string.characters.count > 0  { string += "," }
                string += "\(coordinate)"
            }
            if string.characters.count == 0 { string += "[]" }
            return string
        }
        
        let innerRingsDescription = { () -> String in
            var string: String = ""
            
            var innerRingsGenerator = self.innerRings.generate()
            
            while let ring = innerRingsGenerator.next() {
                
                var ringGenerator = ring.generate()
                
                while let coordinate = ringGenerator.next() {
                    if string.characters.count > 0  { string += "," }
                    string += "\(coordinate)"
                }
            }
            
            if string.characters.count == 0 { string += "[]" }
            return string
        }
        return "\(self.dynamicType)(\(outerRingDescription()),\(innerRingsDescription()))"
    }
    
    public var debugDescription : String {
        return  self.description
    }
}
