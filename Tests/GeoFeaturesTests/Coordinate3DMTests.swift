///
///  Coordinate3DMTests.swift
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

class Coordinate3DMTests: XCTestCase {

    // MARK: Coordinate3DM

    func testInit_XYZM () {
        let coordinate = Coordinate3DM(x: 2.0, y: 3.0, z: 4.0, m: 5.0)

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
        XCTAssertEqual(coordinate.m, 5.0)
    }

    func testX () {
        XCTAssertEqual(Coordinate3DM(x: 1001.0, y: 1002.0, z: 1003.0, m: 1004.0).x, 1001.0)
    }

    func testY () {
        XCTAssertEqual(Coordinate3DM(x: 1001.0, y: 1002.0, z: 1003.0, m: 1004.0).y, 1002.0)
    }

    func testZ () {
        XCTAssertEqual(Coordinate3DM(x: 1001.0, y: 1002.0, z: 1003.0, m: 1004.0).z, 1003.0)
    }

    func testM () {
        XCTAssertEqual(Coordinate3DM(x: 1001.0, y: 1002.0, z: 1003.0, m: 1004.0).m, 1004.0)
    }

    // MARK: TupleConvertible

    func testInit_Tuple () {
        let coordinate = Coordinate3DM(tuple: (x: 2.0, y: 3.0, z: 4.0, m: 5.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
        XCTAssertEqual(coordinate.m, 5.0)
    }

    func testTuple () {
        let coordinate = Coordinate3DM(tuple: (x: 2.0, y: 3.0, z: 4.0, m: 5.0))
        let expected   = (x: 2.0, y: 3.0, z: 4.0, m: 5.0)

        XCTAssertTrue(coordinate.tuple == expected, "\(coordinate.tuple) is not equal to \(expected)")
    }

    // MARK: _ArrayConstructable

    func testInit_Array () throws {
        let coordinate = try Coordinate3DM(array: [2.0, 3.0, 4.0, 5.0])

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
        XCTAssertEqual(coordinate.m, 5.0)
    }

    func testInit_Array_Invalid_ToSmall() {

        let input = [2.0, 1.0, 3.0]
        let expected = "Invalid array size (3)."

        XCTAssertThrowsError(try Coordinate3DM(array: input)) { error in

            if case _ArrayConstructableError.invalidArraySize(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testInit_Array_Invalid_ToLarge() {

        let input = [2.0, 3.0, 4.0, 5.0, 6.0]
        let expected = "Invalid array size (5)."

        XCTAssertThrowsError(try Coordinate3DM(array: input)) { error in

            if case _ArrayConstructableError.invalidArraySize(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    // MARK: CopyConstructable

    func testInit_Copy () {
        let coordinate = Coordinate3DM(other: Coordinate3DM(x: 2.0, y: 3.0, z: 4.0, m: 5.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
        XCTAssertEqual(coordinate.m, 5.0)
    }

    func testInit_Copy_FixedPrecision () {
        let coordinate = Coordinate3DM(other: Coordinate3DM(x: 2.001, y: 3.001, z: 4.001, m: 5.001), precision: FixedPrecision(scale: 100))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
        XCTAssertEqual(coordinate.m, 5.0)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let coordinate = Coordinate3DM(x: 2.0, y: 3.0, z: 4.0, m: 5.0)

        XCTAssertEqual(coordinate.description, "(x: 2.0, y: 3.0, z: 4.0, m: 5.0)")
    }

    func testDebugDescription() {
        let coordinate = Coordinate3DM(x: 2.0, y: 3.0, z: 4.0, m: 5.0)

        XCTAssertEqual(coordinate.debugDescription, "(x: 2.0, y: 3.0, z: 4.0, m: 5.0)")
    }

    // MARK: Equal

    func testEqual () {
        XCTAssertEqual(Coordinate3DM(tuple: (x: 1.0, y: 1.0, z: 4.0, m: 5.0)), Coordinate3DM(tuple: (x: 1.0, y: 1.0, z: 4.0, m: 5.0)))
    }

    func testNotEqual () {
        XCTAssertNotEqual(Coordinate3DM(tuple: (x: 1.0, y: 1.0, z: 4.0, m: 5.0)), Coordinate3DM(tuple: (x: 2.0, y: 2.0, z: 4.0, m: 5.0)))
    }

    // MARK: Hashable

    func testHashValue_Zero () {
        let zero         = Coordinate3DM(tuple: (x: 0.0, y: 0.0, z: 0.0, m: 0.0))
        let negativeZero = Coordinate3DM(tuple: (x: -0.0, y: -0.0, z: -0.0, m: -0.0))

        XCTAssertEqual(zero.hashValue, negativeZero.hashValue)
    }

    func testHashValue_PositiveValue () {
        let zero = Coordinate3DM(tuple: (x: 0.0, y: 0.0, z: 0.0, m: 0.0))
        var last = zero
        let limit = 10000

        for n in -limit...limit {

            let input    = Coordinate3DM(tuple: (x: Double(n), y: Double(n), z: Double(n), m: Double(n)))
            let expected = Coordinate3DM(tuple: (x: Double(n), y: Double(n), z: Double(n), m: Double(n)))

            XCTAssertEqual   (input.hashValue, expected.hashValue)
            XCTAssertNotEqual(input.hashValue, last.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")

            if n != 0 {
                XCTAssertNotEqual(input.hashValue, zero.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")
            }
            last = input
        }
    }
}
