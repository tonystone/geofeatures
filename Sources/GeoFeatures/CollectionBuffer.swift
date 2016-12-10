///
///  CollectionBuffer.swift
///
///  Copyright (c) 2016 Tony Stone
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
///  Created by Tony Stone on 3/12/2016.
///
import Swift

internal struct CollectionBufferHeader {
    var capacity: Int
    var count: Int
}

internal class CollectionBuffer<E>: ManagedBuffer<CollectionBufferHeader, E> {

    internal typealias Element = E

    deinit {
        self.withUnsafeMutablePointers { header, elements -> Void in
            elements.deinitialize(count: header.pointee.count)
            header.deinitialize()
        }
    }
}

internal extension CollectionBuffer {

    func clone() -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElements -> CollectionBuffer<Element> in

            return CollectionBuffer<Element>.create(minimumCapacity: self.header.capacity) { newBuffer in

                newBuffer.withUnsafeMutablePointerToElements { newElements -> Void in
                    newElements.initialize(from: oldElements, count: self.header.count)
                }

                return CollectionBufferHeader(capacity: self.header.capacity, count: self.header.count)

            } as! CollectionBuffer<Element> // swiftlint:disable:this force_cast

        }
    }

    func resize(_ newSize: Int) -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElems -> CollectionBuffer<Element> in

            let elementCount = self.header.count

            return CollectionBuffer<Element>.create(minimumCapacity: newSize) { newBuffer -> CollectionBufferHeader in

                newBuffer.withUnsafeMutablePointerToElements { newElements -> Void in

                    newElements.moveInitialize(from: oldElems, count: elementCount)
                }

                // Clear the old buffer since we moved the values
                self.header.count = 0

                return CollectionBufferHeader(capacity: newSize, count: elementCount)

            } as! CollectionBuffer<Element> // swiftlint:disable:this force_cast
        }
    }
}

internal extension CollectionBuffer {

    func append(_ newElement: Element) {

        self.withUnsafeMutablePointers { (header, elements) -> Void in

            elements.advanced(by: header.pointee.count).initialize(to: newElement)
            header.pointee.count += 1
        }
    }

    func insert(_ newElement: Element, at index: Int) {
        guard (index >= 0) && (index < self.header.count) else { preconditionFailure("Index out of range, can't insert \(Element.self).") }

        self.withUnsafeMutablePointers { (header, elements) -> Void in

            var m = header.pointee.count &- 1

            header.pointee.count = header.pointee.count &+ 1

            // Move the other elements
            while  m >= index {
                elements.advanced(by: m &+ 1).moveInitialize(from: elements.advanced(by: m), count: 1)
                m = m &- 1
            }

            elements.advanced(by: index).initialize(to: newElement)
        }
    }

    func update(_ newElement: Element, at index: Int) {
           guard (index >= 0) && (index < self.header.count) else { preconditionFailure("Index out of range.") }

            self.withUnsafeMutablePointerToElements { elements->Void in
                let element = elements.advanced(by: index)

                element.deinitialize()
                element.initialize(to: newElement)
            }
    }

    func remove(at index: Int) -> Element {
        guard (index >= 0) && (index < self.header.count) else { preconditionFailure("Index out of range, can't remove \(Element.self).") }

        return self.withUnsafeMutablePointers { (header, elements) -> Element in

            /// Move the element to the variable so it can be returned
            let result = (elements + index).move()

            /// Decrement the count of items since we removed it
            header.pointee.count = header.pointee.count &- 1

            var m = index

            // Move the other elements
            while  m <  header.pointee.count {
                elements.advanced(by: m).moveInitialize(from: elements.advanced(by: m &+ 1), count: 1)
                m = m &+ 1
            }
            return result
        }
    }

    func removeLast() -> Element {
        guard self.header.count > 0 else { preconditionFailure("can't removeLast from an empty Collection.") }

        return self.withUnsafeMutablePointers { (header, elements) -> Element in

            // No need to check for overflow in `header.pointee.count - 1` because `header.pointee.count` is known to be positive.
            header.pointee.count = header.pointee.count &- 1
            return elements.advanced(by: header.pointee.count).move()
        }
    }
}
