///
///  Coordinate2DMTests.swift
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
///  Created by Tony Stone on 2/10/2016.
///
import XCTest
import GeoFeatures

class Coordinate2DMTests: XCTestCase {

    // MARK: Coordinate2DM

    func testInitWithXYM () {
        let coordinate = Coordinate2DM(x: 2.0, y: 3.0, m: 4.0)

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.m, 4.0)
    }

    func testX () {
        XCTAssertEqual(Coordinate2DM(x: 1001.0, y: 1002.0, m: 1003.0).x, 1001.0)
    }

    func testY () {
        XCTAssertEqual(Coordinate2DM(x: 1001.0, y: 1002.0, m: 1003.0).y, 1002.0)
    }

    func testM () {
        XCTAssertEqual(Coordinate2DM(x: 1001.0, y: 1002.0, m: 1003.0).m, 1003.0)
    }

    // MARK: TupleConvertible

    func testInitWithTuple () {
        let coordinate = Coordinate2DM(tuple: (x: 2.0, y: 3.0, m: 4.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.m, 4.0)
    }

    func testTuple () {
        let coordinate = Coordinate2DM(tuple: (x: 2.0, y: 3.0, m: 4.0))
        let expected   = (x: 2.0, y: 3.0, m: 4.0)

        XCTAssertTrue(coordinate.tuple == expected, "\(coordinate.tuple) is not equal to \(expected)")
    }

    // MARK: ArrayConstructable

    func testInitWithArray () throws {
        let coordinate = try Coordinate2DM(array: [2.0, 3.0, 4.0])

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.m, 4.0)
    }

    func testInitArrayWithInvalidToSmall() {

        let input = [2.0, 3.0]
        let expected = "Invalid array size (2)."

        XCTAssertThrowsError(try Coordinate2DM(array: input)) { error in

            if case _ArrayConstructableError.invalidArraySize(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testInitWithArrayInvalidToLarge() {

        let input = [2.0, 3.0, 4.0, 5.0]
        let expected = "Invalid array size (4)."

        XCTAssertThrowsError(try Coordinate2DM(array: input)) { error in

            if case _ArrayConstructableError.invalidArraySize(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    // MARK: CopyConstructable

    func testInitCopy () {
        let coordinate = Coordinate2DM(other: Coordinate2DM(x: 2.0, y: 3.0, m: 4.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.m, 4.0)
    }

    func testInitCopyWithFixedPrecision () {
        let coordinate = Coordinate2DM(other: Coordinate2DM(x: 2.002, y: 3.003, m: 4.004), precision: FixedPrecision(scale: 100))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.m, 4.0)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let coordinate = Coordinate2DM(x: 2.0, y: 3.0, m: 4.0)

        XCTAssertEqual(coordinate.description, "(x: 2.0, y: 3.0, m: 4.0)")
    }

    func testDebugDescription() {
        let coordinate = Coordinate2DM(x: 2.0, y: 3.0, m: 4.0)

        XCTAssertEqual(coordinate.debugDescription, "(x: 2.0, y: 3.0, m: 4.0)")
    }

    // MARK: Equal

    func testEqual () {
        XCTAssertEqual(Coordinate2DM(tuple: (x: 1.0, y: 1.0, m: 4.0)), Coordinate2DM(tuple: (x: 1.0, y: 1.0, m: 4.0)))
    }

    func testNotEqual () {
        XCTAssertNotEqual(Coordinate2DM(tuple: (x: 1.0, y: 1.0, m: 4.0)), Coordinate2DM(tuple: (x: 2.0, y: 2.0, m: 4.0)))
    }

    // MARK: Hashable

    func testHashValueWithZero () {
        let zero = Coordinate2DM(tuple: (x: 0.0, y: 0.0, m: 0.0))
        let negativeZero = Coordinate2DM(tuple: (x: -0.0, y: -0.0, m: -0.0))

        XCTAssertEqual(zero.hashValue, negativeZero.hashValue)
    }

    func testHashValueWithPositiveValue () {
        let zero = Coordinate2DM(tuple: (x: 0.0, y: 0.0, m: 0.0))
        var last = zero
        let limit = 10000

        for n in -limit...limit {

            let input    = Coordinate2DM(tuple: (x: Double(n), y: Double(n), m: Double(n)))
            let expected = Coordinate2DM(tuple: (x: Double(n), y: Double(n), m: Double(n)))

            XCTAssertEqual   (input.hashValue, expected.hashValue)
            XCTAssertNotEqual(input.hashValue, last.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")

            if n != 0 {
                XCTAssertNotEqual(input.hashValue, zero.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")
            }
            last = input
        }
    }
}
