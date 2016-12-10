///
///  MultiLineString+GeometryTests.swift
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

private let geometryDimension = Dimension.one    // MultiLineString are always 1 dimension

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class MultiLineStringGeometryCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }

    func testBoundaryWith1ElementInvalid() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateSystem: cs) // Empty Set

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWith2Element() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWith3ElementOpen() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 3.0, y: 3.0))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWith4ElementClosed() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateSystem: cs) // Empty Set

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWith2EqualPoints() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 3.0, y: 3.0)]), LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 3.0, y: 3.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryEmpty() {
        let input = MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateSystem: cs)  // Empty Set

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithOGCMultiCurveA() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.00, y: 1.0), (x: 2.0, y: 2.0), (x: 1.5, y: 3.0), (x: 2.25, y: 4.0)]),
                                                                LineString<Coordinate2D>(elements: [(x: 2.25, y: 4.0), (x: 3.0, y: 3.0), (x: 2.5, y: 2.0), (x: 2.50, y: 1.5)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 2.5, y: 1.5))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithOGCMultiCurveB() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.00, y: 1.0), (x: 2.25, y: 4.0), (x: 2.5, y: 3.0), (x: 1.25, y: 3.5)]),
                                                                LineString<Coordinate2D>(elements: [(x: 10.0, y: 10.0), (x: 20.0, y: 20.0), (x: 30.0, y: 30.0), (x: 10.0, y: 10.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 1.25, y: 3.5))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithOGCMultiCurveC() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.5, y: 3.0), (x: 1.0, y: 4.0), (x: 2.5, y: 3.5), (x: 1.5, y: 3.0)]),
                                                                LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 0.5, y: 2.0), (x: 2.5, y: 3.5), (x: 3.0, y: 1.5), (x: 1.0, y: 1.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithOddIntersection() {
        let input = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.00, y: 1.0), (x: 2.0, y: 2.0), (x: 1.5, y: 3.0), (x: 2.25, y: 4.0)]),
                                                                LineString<Coordinate2D>(elements: [(x: 2.25, y: 4.0), (x: 3.0, y: 3.0), (x: 2.5, y: 2.0), (x: 2.50, y: 1.5)]),
                                                                LineString<Coordinate2D>(elements: [(x: 2.25, y: 4.0), (x: 3.0, y: 5.0), (x: 2.5, y: 5.0), (x: 2.50, y: 6.0)])], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 2.25, y: 4.0)), Point<Coordinate2D>(coordinate: (x: 2.5, y: 6.0)), Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)), Point<Coordinate2D>(coordinate: (x: 2.5, y: 1.5))], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testEqualTrue() {
        let input1 = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), LineString<Coordinate2D>(elements: [(x: 3.0, y: 3.0), (x: 4.0, y: 4.0)])], precision: precision, coordinateSystem: cs)
        let input2 = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), LineString<Coordinate2D>(elements: [(x: 3.0, y: 3.0), (x: 4.0, y: 4.0)])], precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input1, input2)
     }

     func testEqualFalse() {
        let input1            = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)]), LineString<Coordinate2D>(elements: [(x: 3.0, y: 3.0), (x: 4.0, y: 4.0)])], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)], precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
     }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class MultiLineStringGeometryCoordinate2DMFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate2DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class MultiLineStringGeometryCoordinate3DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate3D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class MultiLineStringGeometryCoordinate3DMFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate3DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiLineStringGeometryCoordinate2DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate2D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class MultiLineStringGeometryCoordinate2DMFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate2DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class MultiLineStringGeometryCoordinate3DFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate3D>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class MultiLineStringGeometryCoordinate3DMFixedPrecisionCartesianTests: XCTestCase {

    let precision = FixedPrecision(scale: 100)
    let cs       = Cartesian()

    func testDimension () {
        XCTAssertEqual(MultiLineString<Coordinate3DM>(precision: precision, coordinateSystem: cs).dimension, geometryDimension)
    }
}
