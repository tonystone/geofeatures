///
///  MultiLineString+CurveTests.swift
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
///  Created by Tony Stone on 5/31/2016.
///
import XCTest
import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class MultiLineStringCurveCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testIsClosedClosed() {
        XCTAssertTrue(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 2, y: 0), (x: 0, y: 0)], precision: precision, coordinateSystem: cs),
                LineString<Coordinate2D>(elements: [(x: 0, y: 1), (x: 0, y: 2), (x: 0, y: 3), (x: 2, y: 0), (x: 0, y: 1)], precision: precision, coordinateSystem: cs)
            ], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedOpen() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 0, y: 4), (x: 0, y: 5)], precision: precision, coordinateSystem: cs),
                LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2), (x: 0, y: 3), (x: 0, y: 4), (x: 0, y: 5)], precision: precision, coordinateSystem: cs)
            ], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedEmpty() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs).isClosed())
    }

    func testLength() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 0, y: 2)]), LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 7, y:0)])], precision: precision, coordinateSystem: cs)
        let expected = 9.0

        XCTAssertEqual(input.length(), expected)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiLineStringCurveCoordinate2DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testIsClosedClosed() {
        XCTAssertTrue(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0), (x: 0.0, y: 2.002), (x: 0.0, y: 3.003), (x: 2.002, y: 0.0), (x: 0.0, y: 0.0)], precision: precision, coordinateSystem: cs),
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 1.001), (x: 0.0, y: 2.002), (x: 0.0, y: 3.003), (x: 2.002, y: 0.0), (x: 0.0, y: 1.001)], precision: precision, coordinateSystem: cs)
            ], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedOpen() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0), (x: 0.0, y: 2.0), (x: 0.0, y: 3.003), (x: 0.0, y: 4.004), (x: 0.0, y: 5.001)], precision: precision, coordinateSystem: cs),
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0), (x: 0.0, y: 2.002), (x: 0.0, y: 3.003), (x: 0.0, y: 4.004), (x: 0.0, y: 5.001)], precision: precision, coordinateSystem: cs)
            ], precision: precision, coordinateSystem: cs).isClosed())
    }

    func testIsClosedEmpty() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs).isClosed())
    }

    func testLength() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0), (x: 0.0, y: 2.002)]), LineString<Coordinate2D>(elements: [(x: 0, y: 0), (x: 7.001, y:0)])], precision: precision, coordinateSystem: cs)
        let expected = 9.0

        XCTAssertEqual(input.length(), expected)
    }
}
