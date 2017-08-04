///
///  MultiPolygon+GeometryTests.swift
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

private let geometryDimension = Dimension.two    // MultiPolygon are always 2 dimension

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class MultiPolygonGeometryCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }

    func testBoundaryWithSinglePolygonNoInnerRings() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)])], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithSinglePolygonInnerRings() {
        let input = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]]))], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)]), LineString<Coordinate2D>(elements: [(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)])], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithMultiplePolygons() {
        let input = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)]), LineString<Coordinate2D>(elements: [(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]), LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)])], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryEmpty() {
        let geometry = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs)

        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }

    func testEqualTrue() {
        let input1 = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let input2 = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input1, input2)
    }

    func testEqualWithSameTypesFalse() {
        let input1            = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
    }

    func testEqualWithDifferentTypesFalse() {
        let input1            = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)], precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class MultiPolygonGeometryCoordinate2DMFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate2DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class MultiPolygonGeometryCoordinate3DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate3D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class MultiPolygonGeometryCoordinate3DMFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate3DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiPolygonGeometryCoordinate2DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class MultiPolygonGeometryCoordinate2DMFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate2DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class MultiPolygonGeometryCoordinate3DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate3D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class MultiPolygonGeometryCoordinate3DMFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs        = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiPolygon<Coordinate3DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}
