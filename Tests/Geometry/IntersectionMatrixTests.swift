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
        
        // All values should have the default value
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], IntersectionMatrix.Value.FALSE)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], IntersectionMatrix.Value.FALSE)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], IntersectionMatrix.Value.FALSE)
    }
    
    func testInit_ArrayLiteral() {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.DONTCARE, .TWO,   .DONTCARE],
                                                          [.DONTCARE, .ONE,   .DONTCARE],
                                                          [.DONTCARE, .FALSE, .DONTCARE],
                                                          ]
        )
        // All elements should match input
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], IntersectionMatrix.Value.TWO)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], IntersectionMatrix.Value.ONE)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
    }
    
    func testInit_Pattern_Normal() {
        let matrix = IntersectionMatrix(pattern: "*F*******")
        
        // All values should match the input pattern
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], IntersectionMatrix.Value.DONTCARE)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
    }
    
    func testInit_Pattern_Short_ThrowsAssertion() {
        XCTAssertTrue(true) /// TODO: Unfortunately at this time XCTest has no way of testing assertions so this was tested manually by uncommenting the line below. Change this when XCTest has this ability.
        //XCTAssertThrowsError(IntersectionMatrix(pattern: "*F*"))

    }
    
    func testInit_Pattern_Long_ThrowsAssertion() {
         XCTAssertTrue(true) /// TODO: Unfortunately at this time XCTest has no way of testing assertions so this was tested manually by uncommenting the line below. Change this when XCTest has this ability.
        //XCTAssertThrowsError(IntersectionMatrix(pattern: "*F*******123456789"))
    }
    
    func testMakeIterator() {
        let expectedValues: [IntersectionMatrix.Value] = [.TRUE, .FALSE, .DONTCARE, .ZERO, .ONE, .TWO, .TRUE, .FALSE, .DONTCARE]
        
        let matrix = IntersectionMatrix(pattern: "TF*012TF*")
        
        var index: Int = 0
        
        // All values should match the input pattern using fast enumeration
        for value in matrix {
            XCTAssertEqual(value, expectedValues[index])
            index += 1
        }
    }
    
    func testSubscript_Get() {
        let matrix = IntersectionMatrix(pattern: "TF*012TF*")
        
        // All values should match the input pattern using subscripting
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], IntersectionMatrix.Value.TRUE)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)

        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], IntersectionMatrix.Value.ZERO)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], IntersectionMatrix.Value.ONE)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], IntersectionMatrix.Value.TWO)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], IntersectionMatrix.Value.TRUE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
    }
    
    func testSubscript_Set() {
        var matrix = IntersectionMatrix()
        
        matrix[.INTERIOR, .INTERIOR] = .TRUE
        matrix[.INTERIOR, .BOUNDARY] = .FALSE
        matrix[.INTERIOR, .EXTERIOR] = .DONTCARE
        
        matrix[.BOUNDARY, .INTERIOR] = .ZERO
        matrix[.BOUNDARY, .BOUNDARY] = .ONE
        matrix[.BOUNDARY, .EXTERIOR] = .TWO
        
        matrix[.EXTERIOR, .INTERIOR] = .TRUE
        matrix[.EXTERIOR, .BOUNDARY] = .FALSE
        matrix[.EXTERIOR, .EXTERIOR] = .DONTCARE
        
        // All values should match the input
        XCTAssertEqual(matrix[.INTERIOR, .INTERIOR], IntersectionMatrix.Value.TRUE)
        XCTAssertEqual(matrix[.INTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.INTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
        
        XCTAssertEqual(matrix[.BOUNDARY, .INTERIOR], IntersectionMatrix.Value.ZERO)
        XCTAssertEqual(matrix[.BOUNDARY, .BOUNDARY], IntersectionMatrix.Value.ONE)
        XCTAssertEqual(matrix[.BOUNDARY, .EXTERIOR], IntersectionMatrix.Value.TWO)
        
        XCTAssertEqual(matrix[.EXTERIOR, .INTERIOR], IntersectionMatrix.Value.TRUE)
        XCTAssertEqual(matrix[.EXTERIOR, .BOUNDARY], IntersectionMatrix.Value.FALSE)
        XCTAssertEqual(matrix[.EXTERIOR, .EXTERIOR], IntersectionMatrix.Value.DONTCARE)
    }
    
    func testMatches_True () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.DONTCARE, .TWO,   .DONTCARE],
                                                          [.DONTCARE, .ONE,   .DONTCARE],
                                                          [.DONTCARE, .FALSE, .DONTCARE],
                                                          ]
        )
        // All elements should match input
        XCTAssertTrue(matrix.matches(pattern: "*2**1**F*"))
    }
    
    func testMatches_False () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.DONTCARE, .TWO,   .DONTCARE],
                                                          [.DONTCARE, .ONE,   .DONTCARE],
                                                          [.DONTCARE, .FALSE, .DONTCARE],
                                                          ]
        )
        // All elements should match input
        XCTAssertFalse(matrix.matches(pattern: "*********"))
    }
    
    func testDescription () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.TRUE, .FALSE, .DONTCARE],
                                                          [.ZERO, .ONE,   .TWO],
                                                          [.TRUE, .FALSE, .DONTCARE],
                                                          ]
        )
        // All elements should match input
        XCTAssertEqual(matrix.description, "TF*012TF*")
    }
    
    func testEqual () {
        let input: [[IntersectionMatrix.Value]] = [
                        [.DONTCARE, .TWO,   .DONTCARE],
                        [.DONTCARE, .ONE,   .DONTCARE],
                        [.DONTCARE, .FALSE, .DONTCARE],
                        ]

        XCTAssertEqual(IntersectionMatrix(arrayLiteral: input), IntersectionMatrix(arrayLiteral: input))
    }
    
    func testEqual_False () {
        let input1: [[IntersectionMatrix.Value]] = [
                                                      [.DONTCARE, .TWO,   .DONTCARE],
                                                      [.DONTCARE, .ONE,   .DONTCARE],
                                                      [.DONTCARE, .FALSE, .DONTCARE],
                                                      ]
        let input2: [[IntersectionMatrix.Value]] = [
                                                       [.FALSE,    .TWO,   .FALSE],
                                                       [.DONTCARE, .ONE,   .DONTCARE],
                                                       [.DONTCARE, .FALSE, .DONTCARE],
                                                       ]
        XCTAssertNotEqual(IntersectionMatrix(arrayLiteral: input1), IntersectionMatrix(arrayLiteral: input2))
    }
}
