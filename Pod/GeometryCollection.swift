/*
 *   GeometryCollection.swift
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
 GeometryCollection
 
 A GeometryCollection is a geometric object that is a collection of some number of geometric objects.
 
 All the elements in a GeometryCollection shall be in the same Spatial Reference System. This is also the Spatial
 Reference System for the GeometryCollection.
 
 This is also the Generic Base Collection type that stores a collection of GeometryTypes. It will be specialized for each type that implements it.
 */
public class GeometryCollection<Element where Element : Geometry>: Geometry {

    public convenience init() {
        self.init()
    }
    
    internal init(dimension: Int) {
        super.init(dimension: dimension, precision: defaultPrecision)
    }
    
    public convenience init<C : CollectionType where C.Generator.Element == Element, C.Index.Distance == Int>(elements: C) {
        var elements = ContiguousArray<Element>()
        
        elements.reserveCapacity(elements.count)
        
        var minDimension: Int = 3
        var generator         = elements.generate()
        
        while let element = generator.next() {
            minDimension = min(minDimension, element.dimension)
            
            elements.append(element)
        }
        self.init(dimension: minDimension)
        
        self.elements = elements
    }
    
    public override func isEmpty() -> Bool {
        return self.elements.count == 0
    }
    
    public override func equals(other: GeometryType) -> Bool {
        if let other = other as? GeometryCollection {
            return self.elements.elementsEqual(other, isEquivalent: { (lhs: Geometry, rhs: Geometry) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }
    
    private var elements = ContiguousArray<Element>()
}

// MARK:  Primary accessor methods

extension GeometryCollection {
    
    public var count: Int {
        get { return self.elements.count }
    }
    
    public var capacity: Int {
        get { return self.elements.capacity }
    }
    
    public func reserveCapacity(minimumCapacity: Int) {
        self.elements.reserveCapacity(minimumCapacity)
    }
    
    public func append(newElement: Element) {
        self.elements.append(newElement)
    }
    
    public  func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) {
        self.elements.appendContentsOf(newElements)
    }
    
    public func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
        self.elements.appendContentsOf(newElements)
    }
    
    public func removeLast() -> Element {
        return self.elements.removeLast()
    }
    
    public func insert(newElement: Element, atIndex i: Int) {
        self.elements.insert(newElement, atIndex: i)
    }
    
    public func removeAtIndex(index: Int) -> Element {
        return self.elements.removeAtIndex(index)
    }
    
    public func removeAll(keepCapacity keepCapacity: Bool = true) {
        self.elements.removeAll(keepCapacity: keepCapacity)
    }
}

// MARK: CollectionType conformance

extension GeometryCollection : CollectionType, MutableCollectionType,  _DestructorSafeContainer {
    
    public var startIndex : Int { return self.elements.startIndex }
    public var endIndex   : Int { return self.elements.endIndex }
    
    public subscript(position : Int) -> Element {
        get         { return self.elements[position] }
        set (value) { self.elements[position] = value }
    }
    
    public subscript(range: Range<Int>) -> ArraySlice<Element> {
        get         { return self.elements[range] }
        set (value) { self.elements[range] = value }
    }
    
    public func generate() -> IndexingGenerator<ContiguousArray<Element>> {
        return self.elements.generate()
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible protocol conformance

extension GeometryCollection : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "\(self.dynamicType)(\(self.elements.description))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}

// MARK: Operators

@warn_unused_result
public func !=<T : CollectionType where T.Generator.Element : Geometry>(lhs: T, rhs: T) -> Bool { return false }

@warn_unused_result
public func +=<T : SequenceType where T.Generator.Element : Geometry>(lhs: T, rhs: T)  { }

@warn_unused_result
public func +=<T : CollectionType where T.Generator.Element : Geometry>(lhs: T, rhs: T)  { }

@warn_unused_result
public func -=<T : CollectionType where T.Generator.Element : Geometry>(lhs: T, rhs: T)  { }

@warn_unused_result
public func -=<T : SequenceType where T.Generator.Element : Geometry>(lhs: T, rhs: T)  { }
