/*
 *   LineString.swift
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
 LineString
 
 A LineString is a Curve with linear interpolation between Points. Each consecutive pair of Points defines a Line
 segment.
 A Line is a LineString with exactly 2 Points.
 */
public class LineString: Geometry {
    public typealias Element = Coordinate3D
    
    internal init(dimension: Int, precision: Precision) {
        assert(dimension <= 3)
        
        super.init(dimension: dimension, precision: precision)
    }
    
    public convenience init () {
        self.init(dimension: 0, precision: defaultPrecision)
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double), C.Index.Distance == Int>(coordinates: C, precision: Precision = defaultPrecision) {
        self.init(dimension: 2, precision: precision)
        
        self.coordinates.reserveCapacity(coordinates.count)
        
        var generator = coordinates.generate()
        
        while let (x, y) = generator.next() { self.coordinates.append(precision.convert((x,y, Double.NaN))) }
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == (Double, Double, Double), C.Index.Distance == Int>(coordinates: C, precision: Precision = defaultPrecision) {
        self.init(dimension: 2, precision: defaultPrecision)
        
        self.coordinates.reserveCapacity(coordinates.count)
        
        var generator = coordinates.generate()
        
        while let coordinate = generator.next() { self.coordinates.append(precision.convert(coordinate)) }
    }

    public override func isEmpty() -> Bool {
        return self.coordinates.count == 0
    }
    
    public override func equals(other: GeometryType) -> Bool {
        if let other = other as? LineString {
            return self.coordinates.elementsEqual(other, isEquivalent: { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                return lhs == rhs
            })
        }
        return false
    }
    
    private var coordinates = ContiguousArray<Element>()
}

// MARK: Array conformance

extension LineString {
    
    public var count: Int {
        get { return self.coordinates.count }
    }
    
    public var capacity: Int {
        get { return self.coordinates.capacity }
    }
    
    public func reserveCapacity(minimumCapacity: Int) {
        self.coordinates.reserveCapacity(minimumCapacity)
    }
    
    public func append(newElement: Element) {
        self.coordinates.append(self.precision.convert(newElement))
    }
    
    public func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
        
        var generator = newElements.generate()
        
        while let coordinate = generator.next() {
            self.coordinates.append(precision.convert(coordinate))
        }
    }
    
    public func removeLast() -> Element {
        return self.coordinates.removeLast()
    }
    
    public func insert(newElement: Element, atIndex i: Int) {
        self.coordinates.insert(self.precision.convert(newElement), atIndex: i)
    }
    
    public func removeAtIndex(index: Int) -> Element {
        return self.coordinates.removeAtIndex(index)
    }
    
    public func removeAll(keepCapacity keepCapacity: Bool = true) {
        self.coordinates.removeAll(keepCapacity: keepCapacity)
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible Conformance

extension LineString : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String { return "\(self.dynamicType)(\(self.coordinates.description))" }
    public var debugDescription : String { return self.description }
}

// MARK: CollectionType conformance

extension LineString : CollectionType, MutableCollectionType, _DestructorSafeContainer {
    
    public var startIndex : Int { return self.coordinates.startIndex }
    public var endIndex   : Int { return self.coordinates.endIndex }
    
    public subscript(position : Int) -> Element {
        get         { return self.coordinates[position] }
        set (value) { self.coordinates[position] = value }
    }
    
    public subscript(range: Range<Int>) -> ArraySlice<Element> {
        get         { return self.coordinates[range] }
        set (value) { self.coordinates[range] = value }
    }
    
    public func generate() -> IndexingGenerator<ContiguousArray<Element>> {
        return self.coordinates.generate()
    }
}



