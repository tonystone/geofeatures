///
///  IntersectionMatrixTests.swift
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
///  Created by Tony Stone on 5/8/2016.
///
import XCTest
@testable import GeoFeatures

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
                                                          [.one,   .two,   .empty]
                                                          ]
        )
        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], Dimension.one)

        XCTAssertEqual(matrix[.boundary, .interior], Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], Dimension.zero)

        XCTAssertEqual(matrix[.exterior, .interior], Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], Dimension.two)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }

    func testMakeIterator() {
        let expectedValues = [Dimension.empty, .zero, .one, .two, .empty, .zero, .one, .two, .empty]

        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .zero,  .one],
                                                          [.two,   .empty, .zero],
                                                          [.one,   .two,   .empty]
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
                                                          [.one,   .two,   .empty]
                                                          ]
        )

        XCTAssertEqual(matrix[.interior, .interior], Dimension.empty)
        XCTAssertEqual(matrix[.interior, .boundary], Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], Dimension.one)

        XCTAssertEqual(matrix[.boundary, .interior], Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], Dimension.zero)

        XCTAssertEqual(matrix[.exterior, .interior], Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], Dimension.two)
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
        XCTAssertEqual(matrix[.interior, .boundary], Dimension.zero)
        XCTAssertEqual(matrix[.interior, .exterior], Dimension.one)

        XCTAssertEqual(matrix[.boundary, .interior], Dimension.two)
        XCTAssertEqual(matrix[.boundary, .boundary], Dimension.empty)
        XCTAssertEqual(matrix[.boundary, .exterior], Dimension.zero)

        XCTAssertEqual(matrix[.exterior, .interior], Dimension.one)
        XCTAssertEqual(matrix[.exterior, .boundary], Dimension.two)
        XCTAssertEqual(matrix[.exterior, .exterior], Dimension.empty)
    }

    func testMatches_True () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("TF*012TF*"))
    }

    func testMatches_False () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("TFF012TF1"))
    }

    func testMatches_Match_T () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("T********"))
    }

    func testMatches_Match_F () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("F********"))
    }

    func testMatches_Match_0 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.zero,  .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("0********"))
    }

    func testMatches_Match_1 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.one,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("1********"))
    }

    func testMatches_Match_2 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertTrue(matrix.matches("2********"))
    }

    func testMatches_NoMatch_T () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("T********"))
    }

    func testMatches_NoMatch_F () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.one,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("F********"))
    }

    func testMatches_NoMatch_0 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.one,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("0********"))
    }

    func testMatches_NoMatch_1 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("1********"))
    }

    func testMatches_NoMatch_2 () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("2********"))
    }

    func testMatches_NoMatch_InvalidChar () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("P********"))
    }

    func testMatches_NoMatch_PatternToShort () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.one,   .empty, .empty],
                                                          [.empty, .empty, .empty],
                                                          [.empty, .empty, .empty]
                                                          ]
        )
        XCTAssertFalse(matrix.matches("T****"))
    }

    func testDescription () {
        let matrix = IntersectionMatrix(arrayLiteral: [
                                                          [.two,  .empty, .one],
                                                          [.zero, .one,   .two],
                                                          [.zero, .empty, .empty]
                                                          ]
        )
        XCTAssertEqual(matrix.description, "2, -1, 1, 0, 1, 2, 0, -1, -1")
    }

    func testEqual () {
        let input = [
                                       [Dimension.two,  .empty, .one],
                                       [Dimension.two,  .empty, .two],
                                       [Dimension.zero, .empty, .two]
                                       ]

        XCTAssertEqual(IntersectionMatrix(arrayLiteral: input), IntersectionMatrix(arrayLiteral: input))
    }

    func testEqual_False () {
        let input1 = [
                                       [Dimension.two,  .empty, .one],
                                       [Dimension.two,  .empty, .two],
                                       [Dimension.zero, .empty, .two]
                                       ]

        let input2 = [
                                        [Dimension.one,  .empty, .one],
                                        [Dimension.two,  .empty, .two],
                                        [Dimension.zero, .empty, .two]
                                        ]

        XCTAssertNotEqual(IntersectionMatrix(arrayLiteral: input1), IntersectionMatrix(arrayLiteral: input2))
    }
}
