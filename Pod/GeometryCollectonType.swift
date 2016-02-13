/*
 *   GeometryCollectionType.swift
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

public protocol GeometryCollectionType : CollectionType, MutableCollectionType, _DestructorSafeContainer {
    
    /**
     GeoemetryCollectionType must define its Element
     */
    typealias Element
    
    /**
       GeoemetryCollectionType must be empty constructable
     */
    init ()
    
    /**
        GeoemetryCollectionType can be constructed from any CollectionType including Array as 
        long as it has an Element type equal the GeometryCollectionType Element and the Distance
        is an Int type.
     */
    init<C : CollectionType where C.Generator.Element == Element, C.Index.Distance == Int>(elements: C)
    
    var count: Int { get }
    
    var capacity: Int { get }
    
    mutating func reserveCapacity(minimumCapacity: Int)
    
    mutating func append(newElement: Element)
    
    mutating func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S)
    
    mutating func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C)
    
    mutating func removeLast() -> Element
    
    mutating func insert(newElement: Element, atIndex i: Int)
    
    mutating func removeAtIndex(index: Int) -> Element
    
    mutating func removeAll(keepCapacity keepCapacity: Bool)

}
