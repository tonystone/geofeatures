/*
 *   CollectionBuffer.swift
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
 *   Created by Tony Stone on 3/12/16.
 */
import Swift

internal class CollectionBuffer<E> : ManagedBuffer<Int,E> {

    internal typealias Element = E
    
    deinit {
        self.withUnsafeMutablePointerToElements { elements->Void in
            elements.deinitialize(count: self.header)
        }
    }
}

extension CollectionBuffer {
    
    
    func clone() -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElements->CollectionBuffer<Element> in
            
            return CollectionBuffer<Element>.create(minimumCapacity: self.capacity) { newBuffer in
                
                newBuffer.withUnsafeMutablePointerToElements { newElements->Void in
                    newElements.initialize(from: oldElements, count: self.header)
                }
            
                return self.header
            
            } as! CollectionBuffer<Element>
            
        }
    }
    
    func resize(_ newSize: Int) -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElems->CollectionBuffer<Element> in
            
            let elementCount = self.header
            
            return CollectionBuffer<Element>.create(minimumCapacity: newSize) { newBuffer in
                
                newBuffer.withUnsafeMutablePointerToElements { newElements->Void in
                    
                    newElements.moveInitialize(from: oldElems, count: elementCount)
                }
                
                self.header = 0
                
                return elementCount
        
            } as! CollectionBuffer<Element>
        }
    }
}

