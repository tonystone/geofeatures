//
//  CollectionBuffer.swift
//  Pods
//
//  Created by Tony Stone on 3/12/16.
//
//

import Swift

internal class CollectionBuffer<E> : ManagedBuffer<Int,E> {

    internal typealias Element = E
    
    deinit {
        self.withUnsafeMutablePointerToElements { elements->Void in
            elements.destroy(self.value)
        }
    }
}

extension CollectionBuffer {
    
    func clone() -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElements->CollectionBuffer<Element> in
            
            return CollectionBuffer<Element>.create(self.allocatedElementCount) { newBuffer in
                
                newBuffer.withUnsafeMutablePointerToElements { newElements->Void in
                    newElements.initializeFrom(oldElements, count: self.value)
                }
            
                return self.value
            
            } as! CollectionBuffer<Element>
            
        }
    }
    
    func resize(newSize: Int) -> CollectionBuffer<Element> {
        return self.withUnsafeMutablePointerToElements { oldElems->CollectionBuffer<Element> in
            
            let elementCount = self.value
            
            return CollectionBuffer<Element>.create(newSize) { newBuffer in
                
                newBuffer.withUnsafeMutablePointerToElements { newElements->Void in
                    
                    newElements.moveInitializeFrom(oldElems, count: elementCount)
                }
                
                self.value = 0
                
                return elementCount
        
            } as! CollectionBuffer<Element>
        }
    }
}

