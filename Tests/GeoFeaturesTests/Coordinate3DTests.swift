///
///  Coordinate3DTests.swift
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

class Coordinate3DTests: XCTestCase {

    // MARK: Coordinate3D

    func testInitXYZ () {
        let coordinate = Coordinate3D(x: 2.0, y: 3.0, z: 4.0)

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
    }

    func testX () {
        XCTAssertEqual(Coordinate3D(x: 1001.0, y: 1002.0, z: 1003.0).x, 1001.0)
    }

    func testY () {
        XCTAssertEqual(Coordinate3D(x: 1001.0, y: 1002.0, z: 1003.0).y, 1002.0)
    }

    func testZ () {
        XCTAssertEqual(Coordinate3D(x: 1001.0, y: 1002.0, z: 1003.0).z, 1003.0)
    }

    // MARK: TupleConvertible

    func testInitWithTuple () {
        let coordinate = Coordinate3D(tuple: (x: 2.0, y: 3.0, z: 4.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
    }

    func testTuple () {
        let coordinate = Coordinate3D(tuple: (x: 2.0, y: 3.0, z: 4.0))
        let expected   = (x: 2.0, y: 3.0, z: 4.0)

        XCTAssertTrue(coordinate.tuple == expected, "\(coordinate.tuple) is not equal to \(expected)")
    }

    // MARK: ArrayConstructable

    func testInit_Array () {
        let coordinate = Coordinate3D(array: [2.0, 3.0, 4.0])

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
    }

    func testInit_Array_Invalid () {
        /// TODO: Can't test precondition at this point due to lack of official support in Swift.
    }

    // MARK: CopyConstructable

    func testInitCopy () {
        let coordinate = Coordinate3D(other: Coordinate3D(x: 2.0, y: 3.0, z: 4.0))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
    }

    func testInitCopyWithFixedPrecision () {
        let coordinate = Coordinate3D(other: Coordinate3D(x: 2.002, y: 3.003, z: 4.004), precision: FixedPrecision(scale: 100))

        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
        XCTAssertEqual(coordinate.z, 4.0)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let coordinate = Coordinate3D(x: 2.0, y: 3.0, z: 4.0)

        XCTAssertEqual(coordinate.description, "(x: 2.0, y: 3.0, z: 4.0)")
    }

    func testDebugDescription() {
        let coordinate = Coordinate3D(x: 2.0, y: 3.0, z: 4.0)

        XCTAssertEqual(coordinate.debugDescription, "(x: 2.0, y: 3.0, z: 4.0)")
    }

    // MARK: Equal

    func testEqual () {
        XCTAssertEqual(Coordinate3D(tuple: (x: 1.0, y: 1.0, z: 4.0)), Coordinate3D(tuple: (x: 1.0, y: 1.0, z: 4.0)))
    }

    func testNotEqual () {
        XCTAssertNotEqual(Coordinate3D(tuple: (x: 1.0, y: 1.0, z: 4.0)), Coordinate3D(tuple: (x: 2.0, y: 2.0, z: 4.0)))
    }

    // MARK: Hashable

    func testHashValueWithZero () {
        let zero         = Coordinate3D(tuple: (x: 0.0, y: 0.0, z: 0.0))
        let negativeZero = Coordinate3D(tuple: (x: -0.0, y: -0.0, z: -0.0))

        XCTAssertEqual(zero.hashValue, negativeZero.hashValue)
    }

    func testHashValueWithPositiveValue () {
        let zero = Coordinate3D(tuple: (x: 0.0, y: 0.0, z: 0.0))
        var last = zero
        let limit = 10000

        for n in -limit...limit {

            let input    = Coordinate3D(tuple: (x: Double(n), y: Double(n), z: Double(n)))
            let expected = Coordinate3D(tuple: (x: Double(n), y: Double(n), z: Double(n)))

            XCTAssertEqual   (input.hashValue, expected.hashValue)
            XCTAssertNotEqual(input.hashValue, last.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")

            if n != 0 {
                XCTAssertNotEqual(input.hashValue, zero.hashValue, "\(input.hashValue) is equal to \(zero.hashValue) for input \(input.description)")
            }
            last = input
        }
    }
}
