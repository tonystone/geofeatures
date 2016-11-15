/*
 *   PolygonTests.swift
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
 *   Created by Tony Stone on 11/14/16.
 */
import XCTest
import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class Polygon_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let crs       = Cartesian()

    func testInit() {
        let input = Polygon<Coordinate2D>()

        XCTAssertEqual(input.isEmpty(), true)
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {

        let input    = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 3.0, y: 1.5), (x: 3.0, y: 3.0), (x: 4.0, y: 3.5), (x: 5.0, y: 3.0)]]))
        let expected = "Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 3.0, y: 1.5), (x: 3.0, y: 3.0), (x: 4.0, y: 3.5), (x: 5.0, y: 3.0)]])"

        XCTAssertEqual(input.description, expected)
    }

    func testDebugDescription() {

        let input    = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 3.0, y: 1.5), (x: 3.0, y: 3.0), (x: 4.0, y: 3.5), (x: 5.0, y: 3.0)]]))
        let expected = "Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 3.0, y: 1.5), (x: 3.0, y: 3.0), (x: 4.0, y: 3.5), (x: 5.0, y: 3.0)]])"

        XCTAssertEqual(input.debugDescription, expected)
    }
}
