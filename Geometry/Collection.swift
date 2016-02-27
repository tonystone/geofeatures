/*
 *   Collection.swift
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
 *   Created by Tony Stone on 2/13/16.
 */
import Swift

public protocol Collection: CollectionType, MutableCollectionType, _DestructorSafeContainer {
    
    /**
        Collection must define its Element
     */
    typealias Element
    
//    /**
//        Collections are empty constructable
//     */
//    init()
    
//    init<S : SequenceType where S.Generator.Element == Element>(elements: S, coordinateReferenceSystem: CoordinateReferenceSystem, precision: Precision)
//    
//    init<C : CollectionType where C.Generator.Element == Element>(elements: C, coordinateReferenceSystem: CoordinateReferenceSystem, precision: Precision)
//    
    /**
        - Returns: The number of Geometry objects.
     */
    var count: Int { get }
    
    /**
        - Returns: The current minimum capacity.
     */
    var capacity: Int { get }
    
    /**
        Reserve enough space to store `minimumCapacity` elements.
     
        - Postcondition: `capacity >= minimumCapacity` and the array has
          mutable contiguous storage.
     */
    mutating func reserveCapacity(minimumCapacity: Int)
    
    /**
        Append `newElement`.
     */
    mutating func append(newElement: Element)
    
    /**
        Append the elements of `newElements`.
     */
    mutating func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S)
    
    /**
        Append the elements of `newElements`.
     */
    mutating func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C)
    
    /**
        Remove an element from the end of the Collection.
     
        - Requires: `count > 0`.
     */
    mutating func removeLast() -> Element
    
    /**
        Insert `newElement` at index `i`.
     
        - Requires: `i <= count`.
     */
    mutating func insert(newElement: Element, atIndex i: Int)
    
    /**
        Remove and return the element at index `i`.
     */
    mutating func removeAtIndex(index: Int) -> Element
    
    /**
        Remove all elements.
     
        - Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
     */
    mutating func removeAll(keepCapacity keepCapacity: Bool)
}
