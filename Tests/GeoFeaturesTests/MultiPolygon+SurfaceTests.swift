///
///  MultiPolygon+SurfaceTests.swift
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
///  Created by Tony Stone on 3/29/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiPolygon_Surface_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100000)
    let cs       = Cartesian()

    func testArea_Empty() {
        let input    = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = 0.0

        XCTAssertEqual(input.area(), expected)
    }

    func testArea_2_Same_Polygons() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], [[(x: 1, y: 1), (x: 4, y: 1), (x: 4, y: 2), (x: 1, y: 2), (x: 1, y: 1)]])), Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], [[(x: 1, y: 1), (x: 4, y: 1), (x: 4, y: 2), (x: 1, y: 2), (x: 1, y: 1)]]))], precision: precision, coordinateSystem: cs)
        let expected = 66.0

        XCTAssertEqual(input.area(), expected)
    }

    func testArea_2_Different_Polygons() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], [[(x: 1, y: 1), (x: 4, y: 1), (x: 4, y: 2), (x: 1, y: 2), (x: 1, y: 1)]])), Polygon<Coordinate2D>(rings: ([(x: 0, y: 0), (x: 0, y: 6), (x: 6, y: 6), (x: 6, y: 0), (x: 0, y: 0)], []))], precision: precision, coordinateSystem: cs)
        let expected = 69.0

        XCTAssertEqual(input.area(), expected)
    }
}
