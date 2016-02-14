/*
 *   MultiPoint.swift
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
 MultiPoint
 
 A MultiPoint is a 0-dimensional GeometryCollection. The elements of a MultiPoint are restricted to Points. The Points are not connected or ordered in any semantically important way.
 */
public struct MultiPoint: GeometryCollectionType  {

    public typealias Element = Point
    private var elements = ContiguousArray<Element>()
    
    public let dimension: Int
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem
    
    public init () {
        self.dimension = 0
        self.precision = defaultPrecision
    }
    
    public init<C : CollectionType where C.Generator.Element == Element, C.Index.Distance == Int>(elements: C) {
        var elements = ContiguousArray<Element>()
        
        elements.reserveCapacity(elements.count)
        
        var minDimension: Int = 3
        var generator         = elements.generate()
        
        while let element = generator.next() {
            minDimension = min(minDimension, element.dimension)
            
            elements.append(element)
        }
        
        self.dimension = minDimension
        self.precision = defaultPrecision
        
        self.elements = elements
    }
}

// MARK: CollectionType & MutableCollectionType conformance

extension MultiPoint {
    
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

// MARK:  GeometryCollectionType conformance

extension MultiPoint {
    
    public var count: Int {
        get { return self.elements.count }
    }
    
    public var capacity: Int {
        get { return self.elements.capacity }
    }
    
    public mutating func reserveCapacity(minimumCapacity: Int) {
        self.elements.reserveCapacity(minimumCapacity)
    }
    
    public mutating func append(newElement: Element) {
        self.elements.append(newElement)
    }
    
    mutating  public  func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) {
        self.elements.appendContentsOf(newElements)
    }
    
    public mutating func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
        self.elements.appendContentsOf(newElements)
    }
    
    public mutating func removeLast() -> Element {
        return self.elements.removeLast()
    }
    
    mutating   public func insert(newElement: Element, atIndex i: Int) {
        self.elements.insert(newElement, atIndex: i)
    }
    
    mutating   public func removeAtIndex(index: Int) -> Element {
        return self.elements.removeAtIndex(index)
    }
    
    mutating   public func removeAll(keepCapacity keepCapacity: Bool = true) {
        self.elements.removeAll(keepCapacity: keepCapacity)
    }
}
