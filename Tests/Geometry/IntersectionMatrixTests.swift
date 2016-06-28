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
        
        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .exterior], Dimension.empty)
        
        XCTAssertEqual(matrix[.boundary, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], Dimension.empty)
        
        XCTAssertEqual(matrix[.exterior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.exterior, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }
    
    func testInit_ArrayLiteral() {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .zero,  .one],
                                                          [.two,   .empty, .zero],
                                                          [.one,   .two,   .empty],
                                                          ]
        )
        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], GeoFeatures2.Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], GeoFeatures2.Dimension.one)
        
        XCTAssertEqual(matrix[.boundary, .interior], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], GeoFeatures2.Dimension.zero)
        
        XCTAssertEqual(matrix[.exterior, .interior], GeoFeatures2.Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }
    
    func testMakeIterator() {
        let expectedValues: [GeoFeatures2.Dimension] = [.empty, .zero, .one, .two, .empty, .zero, .one, .two, .empty]
        
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .zero,  .one],
                                                          [.two,   .empty, .zero],
                                                          [.one,   .two,   .empty],
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
                                                          [.empty, .zero,  .one],
                                                          [.two,   .empty, .zero],
                                                          [.one,   .two,   .empty],
                                                          ]
        )
        
        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], GeoFeatures2.Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], GeoFeatures2.Dimension.one)

        XCTAssertEqual(matrix[.boundary, .interior], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], GeoFeatures2.Dimension.zero)
        
        XCTAssertEqual(matrix[.exterior, .interior], GeoFeatures2.Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }
    
    func testSubscript_Set() {
        var matrix = IntersectionMatrix()
        
        matrix[.interior, .interior] = .empty
        matrix[.interior, .boundary] = .zero
        matrix[.interior, .exterior] = .one
        
        matrix[.boundary, .interior] = .two
        matrix[.boundary, .boundary] = .empty
        matrix[.boundary, .exterior] = .zero
        
        matrix[.exterior, .interior] = .one
        matrix[.exterior, .boundary] = .two
        matrix[.exterior, .exterior] = .empty
        
        // All values should match the input
        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], GeoFeatures2.Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], GeoFeatures2.Dimension.one)

        XCTAssertEqual(matrix[.boundary, .interior], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], GeoFeatures2.Dimension.zero)
        
        XCTAssertEqual(matrix[.exterior, .interior], GeoFeatures2.Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], GeoFeatures2.Dimension.two)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }
    
    func testMatches_True () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty],
                                                          ]
        )
        XCTAssertTrue(matrix.matches("TF*012TF*"))
    }

    func testMatches_False () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty],
                                                          ]
        )
        XCTAssertFalse(matrix.matches("TFF012TF1"))
    }
    
    func testDescription () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty],
                                                          ]
        )
        XCTAssertEqual(matrix.description, "2, -1, 1, 0, 1, 2, 0, -1, -1")
    }
    
    func testEqual () {
        let input: [[GeoFeatures2.Dimension]] = [
                                       [.two,  .empty, .one],
                                       [.two,  .empty, .two],
                                       [.zero, .empty, .two],
                                       ]

        XCTAssertEqual(IntersectionMatrix(arrayLiteral: input), IntersectionMatrix(arrayLiteral: input))
    }
    
    func testEqual_False () {
        let input1: [[GeoFeatures2.Dimension]] = [
                                       [.two,  .empty, .one],
                                       [.two,  .empty, .two],
                                       [.zero, .empty, .two],
                                       ]
        
        let input2: [[GeoFeatures2.Dimension]] = [
                                        [.one,  .empty, .one],
                                        [.two,  .empty, .two],
                                        [.zero, .empty, .two],
                                        ]
        
        XCTAssertNotEqual(IntersectionMatrix(arrayLiteral: input1), IntersectionMatrix(arrayLiteral: input2))
    }
}
