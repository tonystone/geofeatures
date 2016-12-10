///
///  Collection.swift
///
///  Copyright 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 2/13/16.
///
import Swift

public protocol Collection: Swift.Collection, MutableCollection, _DestructorSafeContainer {

    ///
    /// Collection must define its Element
    ///
    associatedtype Element

    ///
    /// Collections are empty constructable
    ///
    init(precision: Precision, coordinateSystem: CoordinateSystem)

    ///
    ///Collection can be constructed from any Swift.Collection including Array as
    /// long as it has an Element type equal Self.Element and the Distance
    /// is an Int type.
    ///
    init<C: Swift.Collection>(elements: C, precision: Precision, coordinateSystem: CoordinateSystem)
            where C.Iterator.Element == Element

    ///
    /// - Returns: The number of Geometry objects.
    ///
    var count: Int { get }

    ///
    /// - Returns: The current minimum capacity.
     ///
    var capacity: Int { get }

    ///
    /// Reserve enough space to store `minimumCapacity` elements.
    ///
    /// - Postcondition: `capacity >= minimumCapacity` and the array has
    ///   mutable contiguous buffer.
    ///
    mutating func reserveCapacity(_ minimumCapacity: Int)

    ///
    /// Append `newElement`.
    ///
    mutating func append(_ newElement: Element)

    ///
    /// Append the elements of `newElements`.
    ///
    mutating func append<C: Swift.Collection>(contentsOf newElements: C)
            where C.Iterator.Element == Element

    ///
    /// Insert `newElement` at index `i`.
    ///
    /// - Requires: `i <= count`.
    ///
    mutating func insert(_ newElement: Element, at i: Int)

    ///
    /// Remove and return the element at index `i`.
    ///
    @discardableResult
    mutating func remove(at index: Int) -> Element

    ///
    /// Remove an element from the end of the Collection.
    ///
    /// - Requires: `count > 0`.
    ///
    @discardableResult
    mutating func removeLast() -> Element

    ///
    /// Remove all elements.
    ///
    /// - Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
    ///
    mutating func removeAll(keepingCapacity keepCapacity: Bool)
}
