///
///  PointTests.swift
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

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class Point_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.001)
        XCTAssertEqual(input.y, 1.001)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let input = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.description, "Point<Coordinate2D>(x: 1.001, y: 1.001)")
    }

    func testDebugDescription() {
        let input = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.debugDescription, "Point<Coordinate2D>(x: 1.001, y: 1.001)")
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class Point_Coordinate2DM_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.001)
        XCTAssertEqual(input.y, 1.001)
        XCTAssertEqual(input.m, 1.001)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let input = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.description, "Point<Coordinate2DM>(x: 1.001, y: 1.001, m: 1.001)")
    }

    func testDebugDescription() {
        let input = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.debugDescription, "Point<Coordinate2DM>(x: 1.001, y: 1.001, m: 1.001)")
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class Point_Coordinate3D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.001)
        XCTAssertEqual(input.y, 1.001)
        XCTAssertEqual(input.z, 1.001)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let input = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.description, "Point<Coordinate3D>(x: 1.001, y: 1.001, z: 1.001)")
    }

    func testDebugDescription() {
        let input = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.debugDescription, "Point<Coordinate3D>(x: 1.001, y: 1.001, z: 1.001)")
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class Point_Coordinate3DM_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.001)
        XCTAssertEqual(input.y, 1.001)
        XCTAssertEqual(input.z, 1.001)
        XCTAssertEqual(input.m, 1.001)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {
        let input = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.description, "Point<Coordinate3DM>(x: 1.001, y: 1.001, z: 1.001, m: 1.001)")
    }

    func testDebugDescription() {
        let input = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.debugDescription, "Point<Coordinate3DM>(x: 1.001, y: 1.001, z: 1.001, m: 1.001)")
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class Point_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.0)
        XCTAssertEqual(input.y, 1.0)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class Point_Coordinate2DM_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.0)
        XCTAssertEqual(input.y, 1.0)
        XCTAssertEqual(input.m, 1.0)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class Point_Coordinate3D_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.0)
        XCTAssertEqual(input.y, 1.0)
        XCTAssertEqual(input.z, 1.0)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class Point_Coordinate3DM_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testInit() {
        let input = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.x, 1.0)
        XCTAssertEqual(input.y, 1.0)
        XCTAssertEqual(input.z, 1.0)
        XCTAssertEqual(input.m, 1.0)
    }
}
