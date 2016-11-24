///
///  GeometryCollection+GeometryTests.swift
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
///  Created by Tony Stone on 4/24/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

// MARK: - FloatingPrecision, Cartesian -

class GeometryCollection_Geometry_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(GeometryCollection(precision: precision, coordinateSystem: cs).dimension, Dimension.empty)
    }

    func testDimension_Homogeneous_Point () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1))] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.zero)
    }

    func testDimension_Homogeneous_LineString () {
        XCTAssertEqual(GeometryCollection(elements: [LineString<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.one)
    }

    func testDimension_Homogeneous_Polygon () {
        XCTAssertEqual(GeometryCollection(elements: [Polygon<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.two)
    }

    func testDimension_Non_Homogeneous_Point_Polygon () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1)), Polygon<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.two)
    }

    func testDimension_Non_Homogeneous_Point_LineString () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1)), LineString<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.one)
    }

    func testBoundary() {
        let input = GeometryCollection(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]  as [Geometry], precision: precision, coordinateSystem: cs).boundary()
        let expected = GeometryCollection(precision: precision, coordinateSystem: cs) // GeometryCollection will always return an empty GeometryCollection for boundary

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testEqual_True() {
        let input1 = GeometryCollection(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]  as [Geometry], precision: precision, coordinateSystem: cs)
        let input2 = GeometryCollection(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]  as [Geometry], precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input1, input2)
    }

    func testEqual_SameTypes_False() {
        let input1            = GeometryCollection(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]  as [Geometry], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = GeometryCollection(precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
    }

    func testEqual_DifferentTypes_False() {
        let input1            = GeometryCollection(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]  as [Geometry], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)], precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
    }
}

// MARK: - FixedPrecision, Cartesian -

class GeometryCollection_Geometry_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(GeometryCollection(precision: precision, coordinateSystem: cs).dimension, Dimension.empty)
    }

    func testDimension_Homogeneous_Point () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1))] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.zero)
    }

    func testDimension_Homogeneous_LineString () {
        XCTAssertEqual(GeometryCollection(elements: [LineString<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.one)
    }

    func testDimension_Homogeneous_Polygon () {
        XCTAssertEqual(GeometryCollection(elements: [Polygon<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.two)
    }

    func testDimension_Non_Homogeneous_Point_Polygon () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1)), Polygon<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.two)
    }

    func testDimension_Non_Homogeneous_Point_LineString () {
        XCTAssertEqual(GeometryCollection(elements: [Point<Coordinate2D>(coordinate: (x: 1, y: 1)), LineString<Coordinate2D>()] as [Geometry], precision: precision, coordinateSystem: cs).dimension, Dimension.one)
    }
}
