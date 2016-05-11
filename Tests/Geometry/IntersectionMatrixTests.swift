/*
 *   IntersectionMatrixTests.swift
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
import XCTest

#if SWIFT_PACKAGE
    @testable import Geometry
#else
    @testable import GeoFeatures2
#endif

// MARK: - All

class IntersectionMatrixTests: XCTestCase {

    func testInit() {
        let matrix = IntersectionMatrix()
        
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], Dimension.EMPTY)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], Dimension.EMPTY)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], Dimension.EMPTY)
    }
    
    func testInit_ArrayLiteral() {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.EMPTY, .ZERO,  .ONE],
                                                          [.TWO,   .EMPTY, .ZERO],
                                                          [.ONE,   .TWO,   .EMPTY],
                                                          ]
        )
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], Dimension.ZERO)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], Dimension.ONE)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], Dimension.TWO)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], Dimension.ZERO)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], Dimension.ONE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], Dimension.TWO)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], Dimension.EMPTY)
    }
    
    func testMakeIterator() {
        let expectedValues: [Dimension] = [.EMPTY, .ZERO, .ONE, .TWO, .EMPTY, .ZERO, .ONE, .TWO, .EMPTY]
        
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.EMPTY, .ZERO,  .ONE],
                                                          [.TWO,   .EMPTY, .ZERO],
                                                          [.ONE,   .TWO,   .EMPTY],
                                                          ]
        )
        
        var index: Int = 0
        
        for value in matrix {
            XCTAssertEqual(value, expectedValues[index])
            index += 1
        }
    }
    
    func testSubscript_Get() {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.EMPTY, .ZERO,  .ONE],
                                                          [.TWO,   .EMPTY, .ZERO],
                                                          [.ONE,   .TWO,   .EMPTY],
                                                          ]
        )
        
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], Dimension.ZERO)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], Dimension.ONE)

        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], Dimension.TWO)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], Dimension.ZERO)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], Dimension.ONE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], Dimension.TWO)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], Dimension.EMPTY)
    }
    
    func testSubscript_Set() {
        var matrix = IntersectionMatrix()
        
        matrix[.INTERIOR, .INTERIOR] = .EMPTY
        matrix[.INTERIOR, .BOUNDARY] = .ZERO
        matrix[.INTERIOR, .EXTERIOR] = .ONE
        
        matrix[.BOUNDARY, .INTERIOR] = .TWO
        matrix[.BOUNDARY, .BOUNDARY] = .EMPTY
        matrix[.BOUNDARY, .EXTERIOR] = .ZERO
        
        matrix[.EXTERIOR, .INTERIOR] = .ONE
        matrix[.EXTERIOR, .BOUNDARY] = .TWO
        matrix[.EXTERIOR, .EXTERIOR] = .EMPTY
        
        // All values should match the input
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], Dimension.EMPTY)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], Dimension.ZERO)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], Dimension.ONE)

        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], Dimension.TWO)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], Dimension.EMPTY)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], Dimension.ZERO)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], Dimension.ONE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], Dimension.TWO)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], Dimension.EMPTY)
    }
    
    func testMatches_True () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.TWO,  .EMPTY, .ONE],
                                                          [.ZERO, .ONE,   .TWO],
                                                          [.ZERO, .EMPTY, .EMPTY],
                                                          ]
        )
        XCTAssertTrue(matrix.matches(pattern: "TF*012TF*"))
    }

    func testMatches_False () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.TWO,  .EMPTY, .ONE],
                                                          [.ZERO, .ONE,   .TWO],
                                                          [.ZERO, .EMPTY, .EMPTY],
                                                          ]
        )
        XCTAssertFalse(matrix.matches(pattern: "TFF012TF1"))
    }
    
    func testDescription () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.TWO,  .EMPTY, .ONE],
                                                          [.ZERO, .ONE,   .TWO],
                                                          [.ZERO, .EMPTY, .EMPTY],
                                                          ]
        )
        XCTAssertEqual(matrix.description, "2, -1, 1, 0, 1, 2, 0, -1, -1")
    }
    
    func testEqual () {
        let input: [[Dimension]] = [
                                       [.TWO,  .EMPTY, .ONE],
                                       [.TWO,  .EMPTY, .TWO],
                                       [.ZERO, .EMPTY, .TWO],
                                       ]

        XCTAssertEqual(IntersectionMatrix(arrayLiteral: input), IntersectionMatrix(arrayLiteral: input))
    }
    
    func testEqual_False () {
        let input1: [[Dimension]] = [
                                       [.TWO,  .EMPTY, .ONE],
                                       [.TWO,  .EMPTY, .TWO],
                                       [.ZERO, .EMPTY, .TWO],
                                       ]
        
        let input2: [[Dimension]] = [
                                        [.ONE,  .EMPTY, .ONE],
                                        [.TWO,  .EMPTY, .TWO],
                                        [.ZERO, .EMPTY, .TWO],
                                        ]
        
        XCTAssertNotEqual(IntersectionMatrix(arrayLiteral: input1), IntersectionMatrix(arrayLiteral: input2))
    }
}
