///
///  WKTWriterTests.swift
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
///  Created by Paul Chang on 3/9/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

fileprivate struct UnsupportedGeometry: Geometry {

    let precision: Precision = FloatingPrecision()

    let coordinateSystem: CoordinateSystem = Cartesian()

    let dimension: GeoFeatures.Dimension = .one

    func isEmpty() -> Bool {
        return true
    }

    func boundary() -> Geometry {
        return GeometryCollection()
    }

    func equals(_ other: Geometry) -> Bool { return false }
}

// MARK: - Coordinate2D -

class WKTWriterCoordinate2DTests: XCTestCase {

    var writer = WKTWriter<Coordinate2D>()

    // MARK: - General

    func testWriteUnsupportedGeometry() {

        XCTAssertEqual("", writer.write(UnsupportedGeometry()))
    }

    func testWritePoint() {

        XCTAssertEqual("POINT (1.0 1.0)", writer.write(Point<Coordinate2D>(coordinate: (x:1.0, y:1.0))))
    }

    func testWriteLineStringEmpty() {

        let emptyLineString = LineString<Coordinate2D>()

        XCTAssertEqual("LINESTRING EMPTY", writer.write(emptyLineString))
    }

    func testWriteLineStringsinglePoint() {

        XCTAssertEqual("LINESTRING (1.0 1.0)", writer.write(LineString<Coordinate2D>(elements: [(x:1.0, y:1.0)])))
    }

    func testWriteLineStringmultiplePoints() {

        XCTAssertEqual("LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)", writer.write(LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0)])))
    }

    func testWriteLinearRingEmpty() {

        let emptyLinearRing = LinearRing<Coordinate2D>()

        XCTAssertEqual("LINEARRING EMPTY", writer.write(emptyLinearRing))
    }

    func testWriteLinearRing() {

        XCTAssertEqual("LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)", writer.write(LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])))
    }

    func testWritePolygonEmpty() {

        XCTAssertEqual("POLYGON EMPTY", writer.write(Polygon<Coordinate2D>()))
    }

    func testWritePolygon() {

        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])

        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))", writer.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])))
    }

    func testWritePolygonZeroInnerRings() {

        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])

        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0))", writer.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [])))
    }

    func testWriteMultiPointEmpty() {

        let emptyMultiPoint = MultiPoint<Coordinate2D>(elements: [])

        XCTAssertEqual("MULTIPOINT EMPTY", writer.write(emptyMultiPoint))
    }

    func testWriteMultiPointSinglePoint() {

        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0))])

        XCTAssertEqual("MULTIPOINT ((1.0 1.0))", writer.write(multiPoint))
    }

    func testWriteMultiPointTwoPoints() {

        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0)), Point<Coordinate2D>(coordinate: (x:2.0, y:2.0))])

        XCTAssertEqual("MULTIPOINT ((1.0 1.0), (2.0 2.0))", writer.write(multiPoint))
    }

    func testWriteMultiLineStringEmpty() {

        let multiLineString = MultiLineString<Coordinate2D>(elements: [])

        XCTAssertEqual("MULTILINESTRING EMPTY", writer.write(multiLineString))
    }

    func testWriteMultiLineStringSingleLineString() {

        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)])])

        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0))", writer.write(multiLineString))
    }

    func testWriteMultiLineStringMultipleLineString() {

        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)]), LineString<Coordinate2D>(elements: [(x:3.0, y:3.0), (x:4.0, y:4.0)])])

        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))", writer.write(multiLineString))
    }

    func testWriteMultiPolygonEmpty() {

        let emptyMultiPolygon = MultiPolygon<Coordinate2D>()

        XCTAssertEqual("MULTIPOLYGON EMPTY", writer.write(emptyMultiPolygon))
    }

    func testWriteMultiPolygon() {
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])

        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)), ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)))", writer.write(MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])])))
    }

    func testWriteGeometryCollection() {

        var geometryCollection = GeometryCollection()

        geometryCollection.append(Point<Coordinate2D>(coordinate: (x:1.0, y:2.0)))
        geometryCollection.append(Point<Coordinate2D>(coordinate: (x:10.0, y:20.0)))
        geometryCollection.append(LineString<Coordinate2D>(elements: [(x:3.0, y:4.0)]))
        geometryCollection.append(LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)]))
        geometryCollection.append(Polygon<Coordinate2D>(outerRing: LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)]), innerRings: [LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])]))

        XCTAssertEqual("GEOMETRYCOLLECTION (POINT (1.0 2.0), POINT (10.0 20.0), LINESTRING (3.0 4.0), LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)))", writer.write(geometryCollection))
    }
}

// MARK: - Coordinate2DM -

class WKTWriterCoordinate2DMTests: XCTestCase {

    var writer = WKTWriter<Coordinate2DM>()

    func testWritePoint() {

        XCTAssertEqual("POINT M (1.0 2.0 3.0)", writer.write(Point<Coordinate2DM>(coordinate: (x:1.0, y:2.0, m:3.0))))
    }

    func testWriteLineStringEmpty() {

        let emptyLineString = LineString<Coordinate2DM>()

        /// FIXME: should be LINESTRING M EMPTY
        XCTAssertEqual("LINESTRING EMPTY", writer.write(emptyLineString))
    }

    func testWriteLineStringsinglePoint() {

        /// FIXME: should be LINESTRING M [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 2.0)", writer.write(LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0)])))
    }

    func testWriteLineStringmultiplePoints() {

        /// FIXME: should be LINESTRING M [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0)", writer.write(LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0)])))
    }

    func testWriteLinearRingEmpty() {

        let emptyLinearRing = LinearRing<Coordinate2DM>()

        /// FIXME: should be LINEARSTRING M EMPTY
        XCTAssertEqual("LINEARRING EMPTY", writer.write(emptyLinearRing))
    }

    func testWriteLinearRing() {

        /// FIXME: should be LINEARSTRING M [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0)", writer.write(LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m: 2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])))
    }

    func testWritePolygonEmpty() {

        /// FIXME: should be POLYGON M
        XCTAssertEqual("POLYGON EMPTY", writer.write(Polygon<Coordinate2DM>()))
    }

    func testWritePolygon() {

        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])
        let innerRing = LinearRing<Coordinate2DM>(elements: [(x:4.0, y:4.0, m:8.0), (x:5.0, y:5.0, m:10.0), (x:6.0, y:6.0, m:12.0), (x:4.0, y:4.0, m:8.0)])

        /// FIXME: should be POLYGON M [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0))", writer.write(Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing])))
    }

    func testWritePolygonZeroInnerRings() {

        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])

        /// FIXME: should be POLYGON M [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0))", writer.write(Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [])))
    }

    func testWriteMultiPointEmpty() {

        let multiPoint = MultiPoint<Coordinate2DM>(elements: [])

        /// FIXME: should be MULTIPOINT M EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", writer.write(multiPoint))
    }

    func testWriteMultiPointSinglePoint() {

        let multiPoint = MultiPoint<Coordinate2DM>(elements: [Point<Coordinate2DM>(coordinate: (x:1.0, y:1.0, m: 2.0))])

        /// FIXME: should be MULTIPOINT M [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0))", writer.write(multiPoint))
    }

    func testWriteMultiPointTwoPoints() {

        let multiPoint = MultiPoint<Coordinate2DM>(elements: [Point<Coordinate2DM>(coordinate: (x:1.0, y:1.0, m:2.0)), Point<Coordinate2DM>(coordinate: (x:2.0, y:2.0, m:4.0))])

        /// FIXME: should be MULTIPOINT M
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0), (2.0 2.0 4.0))", writer.write(multiPoint))
    }

    func testWriteMultiLineStringEmpty() {

        let multiLineString = MultiLineString<Coordinate2DM>(elements: [])

        /// FIXME: should be MULTILINESTRING M EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", writer.write(multiLineString))
    }

    func testWriteMultiLineStringSingleLineString() {

        let multiLineString = MultiLineString<Coordinate2DM>(elements: [LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m: 2.0), (x:2.0, y:2.0, m:4.0)])])

        /// FIXME: should be MULTILINESTRING M [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 2.0, 2.0 2.0 4.0))", writer.write(multiLineString))
    }

    func testWriteMultiLineStringMultipleLineString() {

        let multiLineString = MultiLineString<Coordinate2DM>(elements: [LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0)]), LineString<Coordinate2DM>(elements: [(x:3.0, y:3.0, m:6.0), (x:4.0, y:4.0, m:8.0)])])

        /// FIXME: should be MULTILINESTRING M [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 2.0, 2.0 2.0 4.0), (3.0 3.0 6.0, 4.0 4.0 8.0))", writer.write(multiLineString))
    }

    func testWriteMultiPolygonEmpty() {

        let emptyMultiPolygon = MultiPolygon<Coordinate2DM>()

        /// FIXME: should be MULTIPOLYGON M EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", writer.write(emptyMultiPolygon))
    }

    func testWriteMultiPolygon() {
        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])
        let innerRing = LinearRing<Coordinate2DM>(elements: [(x:4.0, y:4.0, m:8.0), (x:5.0, y:5.0, m:10.0), (x:6.0, y:6.0, m:12.0), (x:4.0, y:4.0, m:8.0)])

        /// FIXME: should be MULTIPOLYGON M [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0)), ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0)))", writer.write(MultiPolygon<Coordinate2DM>(elements: [Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing])])))
    }
}

// MARK: - Coordinate3D -

class WKTWriterCoordinate3DTests: XCTestCase {

    var writer = WKTWriter<Coordinate3D>()

    func testWritePoint() {

        XCTAssertEqual("POINT Z (1.0 2.0 3.0)", writer.write(Point<Coordinate3D>(coordinate: (x:1.0, y:2.0, z:3.0))))
    }

    func testWriteLineStringEmpty() {

        let emptyLineString = LineString<Coordinate3D>()

        /// FIXME: should be LINESTRING Z EMPTY
        XCTAssertEqual("LINESTRING EMPTY", writer.write(emptyLineString))
    }

    func testWriteLineStringsinglePoint() {

        /// FIXME: should be LINESTRING Z (1.0, 1.0, 1.0)
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0)", writer.write(LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0)])))
    }

    func testWriteLineStringmultiplePoints() {

        /// FIXME: should be LINESTRING Z [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0)", writer.write(LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0)])))
    }

    func testWriteLinearRingEmpty() {

        let emptyLinearRing = LinearRing<Coordinate3D>()

        /// FIXME: should be LINEARRING Z EMPTY
        XCTAssertEqual("LINEARRING EMPTY", writer.write(emptyLinearRing))
    }

    func testWriteLinearRing() {

        /// FIXME: should be LINEARRING Z [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0)", writer.write(LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])))
    }

    func testWritePolygonEmpty() {

        /// FIXME: should be POLYGON Z
        XCTAssertEqual("POLYGON EMPTY", writer.write(Polygon<Coordinate3D>()))
    }

    func testWritePolygon() {

        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])
        let innerRing = LinearRing<Coordinate3D>(elements: [(x:4.0, y:4.0, z:4.0), (x:5.0, y:5.0, z:5.0), (x:6.0, y:6.0, z:6.0), (x:4.0, y:4.0, z:4.0)])

        /// FIXME: should be POLYGON Z [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0))", writer.write(Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing])))
    }

    func testWritePolygonZeroInnerRings() {

        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])

        /// FIXME: should be POLYGON Z [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0))", writer.write(Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [])))
    }

    func testWriteMultiPointEmpty() {

        let multiPoint = MultiPoint<Coordinate3D>(elements: [])

        /// FIXME: should be MULTIPOINT Z EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", writer.write(multiPoint))
    }

    func testWriteMultiPointSinglePoint() {

        let multiPoint = MultiPoint<Coordinate3D>(elements: [Point<Coordinate3D>(coordinate: (x:1.0, y:1.0, z: 2.0))])

        /// FIXME: should be MULTIPOINT Z [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0))", writer.write(multiPoint))
    }

    func testWriteMultiPointTwoPoints() {

        let multiPoint = MultiPoint<Coordinate3D>(elements: [Point<Coordinate3D>(coordinate: (x:1.0, y:1.0, z:1.0)), Point<Coordinate3D>(coordinate: (x:2.0, y:2.0, z:2.0))])

        /// FIXME: should be MULTIPOINT Z
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0), (2.0 2.0 2.0))", writer.write(multiPoint))
    }

    func testWriteMultiLineStringEmpty() {

        let multiLineString = MultiLineString<Coordinate3D>(elements: [])

        /// FIXME: should be MULTILINESTRING Z EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", writer.write(multiLineString))
    }

    func testWriteMultiLineStringSingleLineString() {

        let multiLineString = MultiLineString<Coordinate3D>(elements: [LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0)])])

        /// FIXME: should be MULTILINESTRING Z [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0, 2.0 2.0 2.0))", writer.write(multiLineString))
    }

    func testWriteMultiLineStringMultipleLineString() {

        let multiLineString = MultiLineString<Coordinate3D>(elements: [LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0)]), LineString<Coordinate3D>(elements: [(x:3.0, y:3.0, z:3.0), (x:4.0, y:4.0, z:4.0)])])

        /// FIXME: should be MULTILINESTRING Z [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0, 2.0 2.0 2.0), (3.0 3.0 3.0, 4.0 4.0 4.0))", writer.write(multiLineString))
    }

    func testWriteMultiPolygonEmpty() {

        let emptyMultiPolygon = MultiPolygon<Coordinate3D>()

        /// FIXME: should be MULTIPOLYGON Z EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", writer.write(emptyMultiPolygon))
    }

    func testWriteMultiPolygon() {
        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])
        let innerRing = LinearRing<Coordinate3D>(elements: [(x:4.0, y:4.0, z:4.0), (x:5.0, y:5.0, z:5.0), (x:6.0, y:6.0, z:6.0), (x:4.0, y:4.0, z:4.0)])

        /// FIXME: should be MULTIPOLYGON Z [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0)), ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0)))", writer.write(MultiPolygon<Coordinate3D>(elements: [Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing])])))
    }
}

// MARK: - Coordinate3DM -

class WKTWriterCoordinate3DMTests: XCTestCase {

    var writer = WKTWriter<Coordinate3DM>()

    func testWritePoint() {

        XCTAssertEqual("POINT ZM (1.0 2.0 3.0 4.0)", writer.write(Point<Coordinate3DM>(coordinate: (x:1.0, y:2.0, z:3.0, m:4.0))))
    }

    func testWriteLineStringEmpty() {

        let emptyLineString = LineString<Coordinate3DM>()

        /// FIXME: should be LINESTRING ZM EMPTY
        XCTAssertEqual("LINESTRING EMPTY", writer.write(emptyLineString))
    }

    func testWriteLineStringsinglePoint() {

        /// FIXME: should be LINESTRING ZM [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0 3.0)", writer.write(LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0)])))
    }

    func testWriteLineStringmultiplePoints() {

        /// FIXME: should be LINESTRING ZM [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0)", writer.write(LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z: 1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0)])))
    }

    func testWriteLinearRingEmpty() {

        let emptyLinearRing = LinearRing<Coordinate3DM>()

        /// FIXME: should be LINEARSTRING ZM EMPTY
        XCTAssertEqual("LINEARRING EMPTY", writer.write(emptyLinearRing))
    }

    func testWriteLinearRing() {

        /// FIXME: should be LINEARSTRING ZM [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0)", writer.write(LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m: 3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])))
    }

    func testWritePolygonEmpty() {

        /// FIXME: should be POLYGON ZM
        XCTAssertEqual("POLYGON EMPTY", writer.write(Polygon<Coordinate3DM>()))
    }

    func testWritePolygon() {

        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])
        let innerRing = LinearRing<Coordinate3DM>(elements: [(x:4.0, y:4.0, z:4.0, m:12.0), (x:5.0, y:5.0, z:5.0, m:15.0), (x:6.0, y:6.0, z:6.0, m:18.0), (x:4.0, y:4.0, z:4.0, m:12.0)])

        /// FIXME: should be POLYGON ZM [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0))", writer.write(Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing])))
    }

    func testWritePolygonZeroInnerRings() {

        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])

        /// FIXME: should be POLYGON ZM [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0))", writer.write(Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [])))
    }

    func testWriteMultiPointEmpty() {

        let multiPoint = MultiPoint<Coordinate3DM>(elements: [])

        /// FIXME: should be MULTIPOINT ZM EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", writer.write(multiPoint))
    }

    func testWriteMultiPointSinglePoint() {

        let multiPoint = MultiPoint<Coordinate3DM>(elements: [Point<Coordinate3DM>(coordinate: (x:1.0, y:1.0, z: 1.0, m: 3.0))])

        /// FIXME: should be MULTIPOINT ZM [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0 3.0))", writer.write(multiPoint))
    }

    func testWriteMultiPointTwoPoints() {

        let multiPoint = MultiPoint<Coordinate3DM>(elements: [Point<Coordinate3DM>(coordinate: (x:1.0, y:1.0, z:1.0, m:3.0)), Point<Coordinate3DM>(coordinate: (x:2.0, y:2.0, z:2.0, m:6.0))])

        /// FIXME: should be MULTIPOINT ZM
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0 3.0), (2.0 2.0 2.0 6.0))", writer.write(multiPoint))
    }

    func testWriteMultiLineStringEmpty() {

        let multiLineString = MultiLineString<Coordinate3DM>(elements: [])

        /// FIXME: should be MULTILINESTRING ZM EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", writer.write(multiLineString))
    }

    func testWriteMultiLineStringSingleLineString() {

        let multiLineString = MultiLineString<Coordinate3DM>(elements: [LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0)])])

        /// FIXME: should be MULTILINESTRING ZM [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0))", writer.write(multiLineString))
    }

    func testWriteMultiLineStringMultipleLineString() {

        let multiLineString = MultiLineString<Coordinate3DM>(elements: [LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0)]), LineString<Coordinate3DM>(elements: [(x:3.0, y:3.0, z:3.0, m:9.0), (x:4.0, y:4.0, z:4.0, m:12.0)])])

        /// FIXME: should be MULTILINESTRING ZM [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0), (3.0 3.0 3.0 9.0, 4.0 4.0 4.0 12.0))", writer.write(multiLineString))
    }

    func testWriteMultiPolygonEmpty() {

        let emptyMultiPolygon = MultiPolygon<Coordinate3DM>()

        /// FIXME: should be MULTIPOLYGON ZM EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", writer.write(emptyMultiPolygon))
    }

    func testWriteMultiPolygon() {
        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])
        let innerRing = LinearRing<Coordinate3DM>(elements: [(x:4.0, y:4.0, z:4.0, m:12.0), (x:5.0, y:5.0, z:5.0, m:15.0), (x:6.0, y:6.0, z:6.0, m:18.0), (x:4.0, y:4.0, z:4.0, m:12.0)])

        /// FIXME: should be MULTIPOLYGON ZM [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0)), ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0)))", writer.write(MultiPolygon<Coordinate3DM>(elements: [Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing])])))
    }
}
