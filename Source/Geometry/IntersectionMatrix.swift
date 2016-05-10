/*
 *   IntersectionMatrix.swift
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
 *   Created by Tony Stone on 5/8/16.
 */
import Swift

/**
 
 Implementation of the  Dimensionally Extended Nine-Intersection Model (DE-9IM)
 
 ```
 |-------------|------------------|------------------|------------------|
 |             |  INTERIOR        |  BOUNDARY        |  EXTERIOR        |
 |-------------|------------------|------------------|------------------|
 | INTERIOR    | dim(I(a) ∩ I(b)) | dim(I(a) ∩ B(b)) | dim(I(a) ∩ E(b)) |
 |-------------|------------------|------------------|------------------|
 | BOUNDARY    | dim(B(a) ∩ I(b)) | dim(B(a) ∩ B(b)) | dim(B(a) ∩ E(b)) |
 |-------------|------------------|------------------|------------------|
 | EXTERIOR    | dim(E(a) ∩ I(b)) | dim(E(a) ∩ B(b)) | dim(E(a) ∩ E(b)) |
 |-------------|------------------|------------------|------------------|
 ```
 */
internal
struct IntersectionMatrix {
    
    internal
    static let size: Int = 9
    
    internal
    enum Value : Character, CustomStringConvertible {
        case TRUE     = "T"
        case FALSE    = "F"
        case DONTCARE = "*"
        case ZERO     = "0"
        case ONE      = "1"
        case TWO      = "2"
        
        var description: String { get { return String(self.rawValue) } }
    }
    
    internal
    enum Index : Int { case INTERIOR = 0, BOUNDARY, EXTERIOR }
    
    private
    var matrix: [[Value]] =
        [
            [.FALSE, .FALSE, .FALSE],
            [.FALSE, .FALSE, .FALSE],
            [.FALSE, .FALSE, .FALSE]
        ]
}

/**
 Sequence support for IntersectionMatrix
 
 */
extension IntersectionMatrix : Sequence {
    
    /**
        subscript the matrix returning a Value type
     
        - Parameters:
            - row: the row in the matrix expressed as an Index value.
            - col: the column in the matrix expressed as an Index value.
     
     
        Example:
     
            let matrix = IntersectionMatrix()
     
            let value = matrix[.INTERIOR, .BOUNDARY]
     
            matrix[.INTERIOR, .BOUNDARY] = .TRUE
     */
    internal
    subscript (row: Index, col: Index) -> Value {
        
        get {
            return matrix[row.rawValue][col.rawValue]
        }
        
        set (newValue) {
            matrix[row.rawValue][col.rawValue] = newValue
        }
    }
    
    /**
        IntersectionMatrix is a sequence that can be iterated on.
     
       Example:
     
            let matrix = IntersectionMatrix(pattern: “T*T***T**”)
     
            for value in matrix {
                print("\(value)")
            }
     */
    internal
    func makeIterator() -> AnyIterator<Value> {
        
        // keep the index of the next element in the iteration
        var nextRow = Index.INTERIOR.rawValue
        var nextCol = Index.INTERIOR.rawValue - 1
        
        // Construct a AnyGenerator<MatrixSymbol> instance, passing a closure that returns the next element in the iteration
        return AnyIterator<Value> {
            
            if nextCol + 1 <= Index.EXTERIOR.rawValue {     // New col
                nextCol += 1                                // Increment column
            } else {
                if nextRow + 1 <= Index.EXTERIOR.rawValue { // New row
                    nextRow += 1                            // Increment row and
                    nextCol = Index.INTERIOR.rawValue       // reset column
                } else {
                    return nil                              // End of Matrix
                }
            }
            return self.matrix[nextRow][nextCol]
        }
    }
}

extension IntersectionMatrix {
    
    /**
     Constructs an IntersectionMatrix from the charactor
     based pattern such as “T*T***T**”
     
     - parameter pattern: The pattern string consiting of legal charactors from the set of eum Value.
     */
    
    internal
    init(pattern: String) {
        assert(pattern.characters.count == IntersectionMatrix.size, "Invalid pattern, the input pattern must be \(IntersectionMatrix.size) charactors long")
        
        var charactors = pattern.characters.makeIterator()
        
        for row in 0...Index.EXTERIOR.rawValue {
            for col in 0...Index.EXTERIOR.rawValue {
                
                if let charactor = charactors.next() {
                    if let value = Value(rawValue: charactor) {
                        matrix[row][col] = value
                    }
                }
            }
        }
    }
    
    internal
    func matches(pattern: String) -> Bool {
        
        var charactors = pattern.characters.makeIterator()
        
        for row in 0...Index.EXTERIOR.rawValue {
            for col in 0...Index.EXTERIOR.rawValue {
                
                if let charactor = charactors.next() {
                    if matrix[row][col] != Value(rawValue: charactor) {
                        return false
                    }
                } else {
                    return false  // Pattern is too short so it does not match
                }
            }
        }
        return true
    }
    
    
}

extension IntersectionMatrix  {
    
    internal
    init(arrayLiteral elements: [[Value]]) {
        assert(
                elements[Index.INTERIOR.rawValue].count == 3 &&
                elements[Index.BOUNDARY.rawValue].count == 3 &&
                elements[Index.EXTERIOR.rawValue].count == 3
        )
        for row in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
            for col in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
                
                self.matrix[row][col] = elements[row][col]
            }
        }
    }
}

extension IntersectionMatrix : CustomStringConvertible {
    
    public
    var description: String {
        get {
            var string = ""
            for row in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
                for col in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
                    string += self.matrix[row][col].description
                }
            }
            return string
        }
    }
}

extension IntersectionMatrix : Equatable {}

internal
func == (lhs: IntersectionMatrix, rhs: IntersectionMatrix) -> Bool {
    
    for row in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
        for col in 0...IntersectionMatrix.Index.EXTERIOR.rawValue {
            
            if lhs.matrix[row][col] != rhs.matrix[row][col] {
                return false
            }
        }
    }
    return true
}


