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
    A polygon consists of an outer ring with it's coordinates in clockwise order and zero or more inner rings in counter clockwise order.

    - requires: The "outerRing" be oriented clockwise
    - requires: The "innerRings" be oriented counter clockwise
    - requires: isSimple == true
    - requires: isClosed == true for "outerRing" and all "innerRings"
 */
public struct Polygon<CoordinateType : protocol<Coordinate, CopyConstructable>> : Geometry {
    
    public typealias RingType = LinearRing<CoordinateType>
    
    /**
        - returns: The `Precision` of this Polygon
     
        - seealso: `Precision`
     */
    public let precision: Precision
    
    /**
        - returns: The `CoordinateReferenceSystem` of this Polygon
     
        - seealso: `CoordinateReferenceSystem`
     */
    public let coordinateReferenceSystem: CoordinateReferenceSystem

    /**
        - returns: The `LinearRing` representing the outerRing of this Polygon
     
        - seealso: `LinearRing`
     */
    public var outerRing:  RingType   { get { return _outerRing } }
    
    /**
        - returns: An Array of `LinearRing`s representing the innerRings of this Polygon
     
        - seealso: `LinearRing`
     */
    public var innerRings: [RingType] { get { return _innerRings } }

    /**
        A Polygon initializer to create an empty polygon.
     
        - parameters:
            - coordinateReferenceSystem: The 'CoordinateReferenceSystem` this polygon should use in calculations on it's coordinates.
            - precision: The `Precision` model this polygon should use in calculations on it's coordinates.
     
        - seealso: `CollectionType`
        - seealso: `CoordinateReferenceSystem`
        - seealso: `Precision`
     */
    public init (coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        self.coordinateReferenceSystem = coordinateReferenceSystem
        self.precision = precision
    }
    
    /**
        A Polygon can be constructed from any `CollectionType` for it's rings including Array as
        long as it has an Element type equal the `CoordinateType` specified.
     
        - parameters:
            - outerRing: A `CollectionType` who's elements are of type `CoordinateType`.
            - innerRings: An `Array` of `CollectionType` who's elements are of type `CoordinateType`.
            - coordinateReferenceSystem: The 'CoordinateReferenceSystem` this polygon should use in calculations on it's coordinates.
            - precision: The `Precision` model this polygon should use in calculations on it's coordinates.
     
        - seealso: `CollectionType`
        - seealso: `CoordinateReferenceSystem`
        - seealso: `Precision`
     */
    public  init<C : CollectionType where C.Generator.Element == CoordinateType>(outerRing: C, innerRings: [C], coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
       
        self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: precision)
        
        var outerRingsGenerator = outerRing.generate()
        
        self._outerRing.reserveCapacity(numericCast(outerRing.count))
        
        while let coordinate = outerRingsGenerator.next() {
            
            self._outerRing.append(CoordinateType(other: coordinate, precision: precision))
        }
        self._innerRings.reserveCapacity(innerRings.count)
        
        var innerRingsGenerator = innerRings.generate()
        
        while let ring = innerRingsGenerator.next() {
            self._innerRings.append(RingType(elements: ring, precision: precision))
        }
    }
    
    internal var _outerRing = RingType()
    internal var _innerRings = [RingType]()

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
