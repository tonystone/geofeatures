///
///  WKTReaderTests.swift
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

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable type_name

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class WKTReaderCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    private typealias WKTReaderType = WKTReader<Coordinate2D>
    private var wktReader = WKTReaderType(precision: FloatingPrecision(), coordinateSystem: Cartesian())

    // MARK: - Init

    func testReadPointFloatValid() {

        let input = "POINT (1.0 1.0)"
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate2D>, expected)
    }

    func testReadUsingUTF8Data() {

        let input = Data(bytes: Array("POINT (1.0 1.0)".utf8))
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try wktReader.read(data: input) as? Point<Coordinate2D>, expected)
    }

    func testReadUsingUnicodeData() {

        let input = "POINT (1.0 1.0)".data(using: .unicode)!    // swiftlint:disable:this force_unwrapping
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try wktReader.read(data: input, encoding: .unicode) as? Point<Coordinate2D>, expected)
    }

    // MARK: - General

    func testReadDataNotConvertableUsingUTF8() {

        let input = Data(bytes: [0xFF, 0xFF])

        let expected = "The Data object can not be converted using the given encoding 'Unicode (UTF-8)'."

        XCTAssertThrowsError(try wktReader.read(data: input)) { error in

            if case WKTReaderError.invalidData(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadInvalidNumberOfCoordinates() {

        let input = "POINT Z (1.0 1.0 1.0)"
        let expected = "Invalid number of coordinates (3) supplied for type GeoFeatures.Coordinate2D."

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in

            if case WKTReaderError.invalidNumberOfCoordinates(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadInvalidGeometry() {

        let input = "DUMMYTYPE (1.0 1.0)"
        let expected = "Unsupported type -> 'DUMMYTYPE (1.0 1.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unsupportedType(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - Point

    func testReadPointIntValid() {

        let input = "POINT (1 1)"
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate2D>, expected)
    }

    func testReadPointValidExponentUpperCase() {

        let input = "POINT (1.0E-5 1.0E-5)"
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0E-5, y: 1.0E-5))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate2D>, expected)
    }

    func testReadPointValidExponentLowerCase() {

        let input = "POINT (1.0e-5 1.0e-5)"
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0E-5, y: 1.0E-5))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate2D>, expected)
    }

    func testReadPointInvalidCoordinateNoSpace() {

        let input = "POINT (1.01.0)"
        let expected = "Unexpected token at line: 1 column: 12. Expected 'single space' but found -> '.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateX() {

        let input = "POINT (K 1.0)"
        let expected = "Unexpected token at line: 1 column: 8. Expected 'numeric literal' but found -> 'K 1.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateY() {

        let input = "POINT (1.0 K)"
        let expected = "Unexpected token at line: 1 column: 12. Expected 'numeric literal' but found -> 'K)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidWhiteSpace() {

        let input = "POINT  (   1.0     1.0   ) "
        let expected = "Unexpected token at line: 1 column: 6. Expected 'single space' but found -> '  (   1.0     1.0   ) '"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidMissingLeftParen() {

        let input = "POINT 1 1)"
        let expected = "Unexpected token at line: 1 column: 7. Expected '(' but found -> '1 1)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidMissingRightParen() {

        let input = "POINT (1 1"
        let expected = "Unexpected token at line: 1 column: 11. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - LineString

    func testReadLineStringValid() {

        let input = "LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = LineString<Coordinate2D>(elements: [( x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)])

        XCTAssertEqual(try wktReader.read(string: input) as? LineString<Coordinate2D>, expected)
    }

    func testReadLineStringValidEmpty() {

        let input = "LINESTRING EMPTY"
        let expected = LineString<Coordinate2D>(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? LineString<Coordinate2D>, expected)
    }

    func testReadLineStringInvalidWhiteSpace() {

        let input = "LINESTRING   ( 1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 11. Expected 'single space' but found -> '   ( 1.0 1.0, 2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLineStringInvalidDoubleSapceAfterComma() {

        let input = "LINESTRING (1.0 1.0,  2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 21. Expected 'single space' but found -> '  2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLineStringInvalidMissingLeftParen() {

        let input = "LINESTRING 1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 12. Expected '(' but found -> '1.0 1.0, 2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLineStringInvalidMissingRightParen() {

        let input = "LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0"
        let expected = "Unexpected token at line: 1 column: 38. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - LinearRing

    func testReadLinearRingValid() {

        let input = "LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = LinearRing<Coordinate2D>(elements: [( x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)])

        XCTAssertEqual(try wktReader.read(string: input) as? LinearRing<Coordinate2D>, expected)
    }

    func testReadLinearRingValidEmpty() {

        let input = "LINEARRING EMPTY"
        let expected = LinearRing<Coordinate2D>(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? LinearRing<Coordinate2D>, expected)
    }

    func testReadLinearRingInvalidWhiteSpace() {

        let input = "LINEARRING   ( 1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 11. Expected 'single space' but found -> '   ( 1.0 1.0, 2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLinearRingInvalidDoubleSapceAfterComma() {

        let input = "LINEARRING (1.0 1.0,  2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 21. Expected 'single space' but found -> '  2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLinearRingInvalidMissingLeftParen() {

        let input = "LINEARRING 1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 12. Expected '(' but found -> '1.0 1.0, 2.0 2.0, 3.0 3.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadLinearRingInvalidMissingRightParen() {

        let input = "LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0"
        let expected = "Unexpected token at line: 1 column: 38. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - MultiPoint

    func testReadMultiPointValid() {

        let input = "MULTIPOINT ((1.0 2.0), (3.0 4.0))"
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0)), Point<Coordinate2D>(coordinate: (x: 3.0, y: 4.0))])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiPoint<Coordinate2D>, expected)
    }

    func testReadMultiPointValidEmpty() {

        let input = "MULTIPOINT EMPTY"
        let expected = MultiPoint<Coordinate2D>(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiPoint<Coordinate2D>, expected)
    }

    func testReadMultiPointInvalidWhiteSpace() {

        let input = "MULTIPOINT   ((1.0 2.0))"
        let expected = "Unexpected token at line: 1 column: 11. Expected 'single space' but found -> '   ((1.0 2.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPointInvalidDoubleSapceAfterComma() {

        let input = "MULTIPOINT ((1.0 2.0),  (3.0 4.0))"
        let expected = "Unexpected token at line: 1 column: 23. Expected 'single space' but found -> '  (3.0 4.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPointInvalidMissingLeftParen() {

        let input = "MULTIPOINT 1.0 2.0), (3.0 4.0))"
        let expected = "Unexpected token at line: 1 column: 12. Expected '(' but found -> '1.0 2.0), (3.0 4.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPointInvalidMissingRightParen() {

        let input = "MULTIPOINT ((1.0 2.0), (3.0 4.0)"
        let expected = "Unexpected token at line: 1 column: 33. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - MultiLineString

    func testReadMultiLineStringValid() {

        let input = "MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))"
        let expected = MultiLineString<Coordinate2D>(elements: [LineString(elements:  [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)]), LineString(elements:  [(x: 4.0, y: 4.0), (x: 5.0, y: 5.0), (x: 6.0, y: 6.0)])])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiLineString<Coordinate2D>, expected)
    }

    func testReadMultiLineStringValidEmpty() {

        let input = "MULTILINESTRING EMPTY"
        let expected = MultiLineString<Coordinate2D>(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiLineString<Coordinate2D>, expected)
    }

    func testReadMultiLineStringInvalidWhiteSpace() {

        let input = "MULTILINESTRING  ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))"
        let expected = "Unexpected token at line: 1 column: 16. Expected 'single space' but found -> '  ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiLineStringInvalidDoubleSapceAfterComma() {

        let input = "MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0),  (4.0 4.0, 5.0 5.0, 6.0 6.0))"
        let expected = "Unexpected token at line: 1 column: 46. Expected 'single space' but found -> '  (4.0 4.0, 5.0 5.0, 6.0 6.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiLineStringInvalidMissingLeftParen() {

        let input = "MULTILINESTRING 1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))"
        let expected = "Unexpected token at line: 1 column: 17. Expected '(' but found -> '1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiLineStringInvalidMissingRightParen() {

        let input = "MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0)"
        let expected = "Unexpected token at line: 1 column: 74. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - Polygon

    func testReadPolygonZeroInnerRingsValid() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0))"
        let expected = Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: [])

        XCTAssertEqual(try wktReader.read(string: input) as? Polygon<Coordinate2D>, expected)
    }

    func testReadPolygonSingleOuterRingValid() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))"
        let expected = Polygon<Coordinate2D>(outerRing: LinearRing<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: [LinearRing<Coordinate2D>(elements: [(x: 4.0, y: 4.0), (x: 5.0, y: 5.0), (x: 6.0, y: 6.0), (x: 4.0, y: 4.0)])])

        XCTAssertEqual(try wktReader.read(string: input) as? Polygon<Coordinate2D>, expected)
    }

    func testReadPolygonMultipleInnerRingsValid() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = Polygon<Coordinate2D>(outerRing: LinearRing<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: [LinearRing<Coordinate2D>(elements: [(x: 4.0, y: 4.0), (x: 5.0, y: 5.0), (x: 6.0, y: 6.0), (x: 4.0, y: 4.0)]), LinearRing<Coordinate2D>(elements: [(x: 3.0, y: 3.0), (x: 4.0, y: 4.0), (x: 5.0, y: 5.0), (x: 3.0, y: 3.0)])])

        XCTAssertEqual(try wktReader.read(string: input) as? Polygon<Coordinate2D>, expected)
    }

    func testReadPolygonMultipleInnerRingsInvalidMissingComma() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0) (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 46. Expected ',' but found -> ' (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPolygonMultipleInnerRingsInvalidExtraWhiteSpaceInnerRing() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0),  (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 85. Expected 'single space' but found -> '  (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPolygonValidEmpty() {

        let input = "POLYGON EMPTY"
        let expected = Polygon<Coordinate2D>()

        XCTAssertEqual(try wktReader.read(string: input) as? Polygon<Coordinate2D>, expected)
    }

    func testReadPolygonInvalidWhiteSpace() {

        let input = "POLYGON  ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 8. Expected 'single space' but found -> '  ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPolygonInvalidDoubleSapceAfterComma() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0),  (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 47. Expected 'single space' but found -> '  (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPolygonInvalidMissingLeftParen() {

        let input = "POLYGON 1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 9. Expected '(' but found -> '1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPolygonInvalidMissingRightParen() {

        let input = "POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 122. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - MultiPolygon

    func testReadMultiPolygonValid() {

        let input = "MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))"
        let expected = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: []), Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 10.0, y: 10.0), (x: 20.0, y: 20.0), (x: 30.0, y: 30.0), (x: 10.0, y: 10.0)]), innerRings: [])])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiPolygon<Coordinate2D>, expected)
    }

    func testReadMultiPolygonValidEmpty() {

        let input = "MULTIPOLYGON EMPTY"
        let expected = MultiPolygon<Coordinate2D>(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? MultiPolygon<Coordinate2D>, expected)
    }

    func testReadMultiPolygonInvalidWhiteSpace() {

        let input = "MULTIPOLYGON  (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))"
        let expected = "Unexpected token at line: 1 column: 13. Expected 'single space' but found -> '  (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPolygonInvalidDoubleSapceAfterComma() {

        let input = "MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)),  ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))"
        let expected = "Unexpected token at line: 1 column: 54. Expected 'single space' but found -> '  ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPolygonInvalidMissingLeftParen() {

        let input = "MULTIPOLYGON 1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))"
        let expected = "Unexpected token at line: 1 column: 14. Expected '(' but found -> '1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadMultiPolygonInvalidMissingRightParen() {

        let input = "MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0))"
        let expected = "Unexpected token at line: 1 column: 101. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - GoemetryCollection

    func testReadGeometryCollectionValid() {

        let input = "GEOMETRYCOLLECTION (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0), LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0), POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), MULTIPOINT ((1.0 2.0)), MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0)), MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0))), GEOMETRYCOLLECTION (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)))"
        let expected = GeometryCollection(elements:
            [
                Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)),
                LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)]),
                LinearRing<Coordinate2D>(elements: [( x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)]),
                Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: []),
                MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0))]),
                MultiLineString<Coordinate2D>(elements: [LineString(elements:  [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)]), LineString(elements:  [(x: 4.0, y: 4.0), (x: 5.0, y: 5.0), (x: 6.0, y: 6.0)])]),
                MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)]), innerRings: []), Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(x: 10.0, y: 10.0), (x: 20.0, y: 20.0), (x: 30.0, y: 30.0), (x: 10.0, y: 10.0)]), innerRings: [])]),
                GeometryCollection(elements:  [
                    Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)),
                    LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)])] as [Geometry])
                ] as [Geometry])

        XCTAssertEqual(try wktReader.read(string: input) as? GeometryCollection, expected)
    }

    func testReadGeometryCollectionValidEmpty() {

        let input = "GEOMETRYCOLLECTION EMPTY"
        let expected = GeometryCollection(elements: [])

        XCTAssertEqual(try wktReader.read(string: input) as? GeometryCollection, expected)
    }

    func testReadGeometryCollectionInvalidWhiteSpace() {

        let input = "GEOMETRYCOLLECTION  (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 19. Expected 'single space' but found -> '  (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadGeometryCollectionInvalidDoubleSapceAfterComma() {

        let input = "GEOMETRYCOLLECTION (POINT (1.0 1.0),  LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 37. Expected 'single space' but found -> '  LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadGeometryCollectionInvalidMissingLeftParen() {

        let input = "GEOMETRYCOLLECTION POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))"
        let expected = "Unexpected token at line: 1 column: 20. Expected '(' but found -> 'POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadGeometryCollectionInvalidMissingRightParen() {

        let input = "GEOMETRYCOLLECTION (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)"
        let expected = "Unexpected token at line: 1 column: 76. Expected ')' but found -> ''"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - Performance Tests

    func testReadPerformancePolygonCalifornia() {
        let reader = WKTReader<Coordinate2D>(precision: FixedPrecision(scale: 100000))
        let wkt       = "POLYGON ((-123.00111 37.77205, -122.99754 37.77078, -122.99509 37.76913, -122.98741 37.76387, -122.98143 37.75892, -122.9776 37.75498, -122.97545 37.75258, -122.97406 37.74993, -122.97326 37.74865, -122.97045 37.74782, -122.96727 37.7463, -122.9641 37.74428, -122.96106 37.74195, -122.95839 37.73973, -122.95464 37.73683, -122.94998 37.73219, -122.94552 37.72531, -122.94229 37.72106, -122.93971 37.71535, -122.93792 37.70996, -122.93768 37.70924, -122.93586 37.70246, -122.93571 37.69762, -122.93734 37.69093, -122.93903 37.68654, -122.93966 37.68235, -122.94136 37.67658, -122.94501 37.66977, -122.94907 37.66338, -122.95488 37.65835, -122.96301 37.65198, -122.97301 37.64658, -122.98051 37.6439, -122.98675 37.64178, -122.99259 37.64102, -123.00091 37.63993, -123.00111 37.63983, -123.00111 37.64177, -123.0116 37.64151, -123.02715 37.64522, -123.0407 37.65033, -123.05358 37.65865, -123.06358 37.66732, -123.06859 37.67304, -123.07306 37.68258, -123.07492 37.69007, -123.07715 37.69232, -123.08188 37.69684, -123.08606 37.70075, -123.08878 37.70579, -123.0918 37.71187, -123.09285 37.71369, -123.0948 37.71407, -123.09965 37.71359, -123.10492 37.71265, -123.11557 37.71405, -123.11964 37.71544, -123.12611 37.71673, -123.1326 37.71939, -123.14149 37.72616, -123.14913 37.73228, -123.15676 37.73784, -123.16275 37.74353, -123.1667 37.74993, -123.16998 37.75593, -123.17293 37.7636, -123.17376 37.77183, -123.17382 37.77573, -123.17371 37.77611, -123.16911 37.79236, -123.16601 37.79688, -123.16094 37.802, -123.15386 37.80707, -123.15333 37.80744, -123.14721 37.81195, -123.13944 37.81672, -123.13227 37.81968, -123.12611 37.82166, -123.11829 37.82306, -123.10826 37.82254, -123.09526 37.82188, -123.08165 37.81815, -123.07049 37.81383, -123.04882 37.79982, -123.03873 37.78888, -123.0351 37.78043, -123.03384 37.77837, -123.03144 37.77715, -123.02585 37.77709, -123.01697 37.77607, -123.01059 37.77493, -123.00615 37.77352, -119.00093 33.53589, -119.00093 33.53582, -118.99784 33.5342, -118.99445 33.53271, -118.9928 33.53185, -118.99005 33.53029, -118.9862 33.52743, -118.98215 33.52426, -118.9791 33.52065, -118.97654 33.51768, -118.97289 33.51384, -118.97101 33.51066, -118.96831 33.50556, -118.96602 33.50002, -118.9649 33.4953, -118.96276 33.48521, -118.96273 33.4733, -118.96375 33.46683, -118.96676 33.45792, -118.96983 33.45289, -118.97268 33.44317, -118.97848 33.43111, -118.98051 33.42859, -118.98873 33.42344, -118.99598 33.41996, -119.00093 33.41849, -119.00093 33.4213, -119.00952 33.41677, -119.018 33.41505, -119.02704 33.41287, -119.03963 33.41222, -119.05307 33.41102, -119.06412 33.41255, -119.07189 33.4138, -119.07851 33.41677, -119.08651 33.42139, -119.09413 33.42687, -119.10076 33.43524, -119.10378 33.44044, -119.10615 33.44501, -119.10888 33.45115, -119.1088 33.45632, -119.10965 33.46229, -119.10908 33.46894, -119.10957 33.47428, -119.1092 33.48007, -119.10836 33.48578, -119.10791 33.49119, -119.10747 33.49542, -119.10794 33.49518, -119.10721 33.50002, -119.11895 33.50002, -119.11717 33.5056, -119.11508 33.50986, -119.11166 33.51547, -119.10872 33.51926, -119.10421 33.52289, -119.0987 33.52644, -119.09049 33.5303, -119.08374 33.53291, -119.0765 33.53515, -119.07014 33.53642, -119.06616 33.53671, -119.06041 33.53643, -119.05655 33.53603, -119.05394 33.53676, -119.0508 33.53716, -119.04847 33.53729, -119.04706 33.53722, -119.04139 33.53862, -119.03625 33.53962, -119.03074 33.54012, -119.02394 33.54, -119.01735 33.53919, -119.01213 33.53834, -119.00807 33.53755, -118.3289 32.87504, -118.32571 32.87173, -118.31739 32.86377, -118.30489 32.85347, -118.2924 32.83639, -118.28878 32.82083, -118.2899 32.81053, -118.29584 32.79826, -118.30285 32.78885, -118.31853 32.7768, -118.33197 32.77057, -118.35349 32.76581, -118.36427 32.76708, -118.37386 32.76885, -118.37838 32.77023, -118.3812 32.76808, -118.38535 32.76356, -118.39256 32.7585, -118.39952 32.75523, -118.40832 32.75191, -118.4162 32.75059, -118.43654 32.75004, -118.44091 32.75103, -118.45381 32.75511, -118.46471 32.76018, -118.47391 32.76682, -118.48167 32.77472, -118.48497 32.77916, -118.49421 32.7855, -118.50091 32.79203, -118.50765 32.79688, -118.51581 32.79957, -118.52481 32.80472, -118.53178 32.80877, -118.5382 32.81277, -118.54673 32.82068, -118.55319 32.8288, -118.55714 32.83735, -118.56253 32.84944, -118.56735 32.85456, -118.57505 32.86573, -118.58132 32.87152, -118.58794 32.87884, -118.59114 32.88383, -118.59693 32.89047, -118.60352 32.90356, -118.60433 32.90661, -118.60552 32.91243, -118.60547 32.9182, -118.60817 32.92612, -118.61079 32.92931, -118.6186 32.93685, -118.62592 32.94723, -118.62957 32.95363, -118.63387 32.96221, -118.63649 32.96909, -118.63771 32.97536, -118.64049 32.98261, -118.64343 32.99284, -118.64433 32.99777, -118.67017 33.00003, -118.67484 33.01214, -118.67855 33.02636, -118.6756 33.04935, -118.66385 33.06685, -118.6413 33.08188, -118.62592 33.08566, -118.60834 33.08632, -118.58953 33.08711, -118.56492 33.08222, -118.55263 33.07863, -118.53419 33.06786, -118.51497 33.04989, -118.50766 33.03788, -118.50091 33.03059, -118.49113 33.01792, -118.48714 33.00818, -118.48475 33.00462, -118.48141 33.00003, -118.47779 32.99578, -118.47119 32.98912, -118.46018 32.97525, -118.45454 32.96797, -118.44886 32.96175, -118.44215 32.95795, -118.42769 32.94958, -118.41874 32.94211, -118.41127 32.93647, -118.40604 32.93179, -118.39079 32.91784, -118.38644 32.91508, -118.38157 32.91185, -118.37762 32.9096, -118.37591 32.90869, -118.36992 32.90507, -118.36252 32.90012, -118.35639 32.8945, -118.35031 32.88968, -118.34358 32.88443, -118.33746 32.87975, -118.33197 32.87678, -118.30868 33.41669, -118.30713 33.40972, -118.3041 33.40363, -118.28581 33.38984, -118.27721 33.38074, -118.26818 33.37502, -118.25771 33.36413, -118.25138 33.3534, -118.2451 33.33834, -118.24105 33.31303, -118.24594 33.29106, -118.2509 33.28047, -118.25918 33.2725, -118.2807 33.25909, -118.30284 33.25101, -118.30872 33.25003, -118.31862 33.24847, -118.33475 33.24861, -118.34377 33.25003, -118.36331 33.25507, -118.38149 33.2623, -118.38913 33.2652, -118.40256 33.26794, -118.42752 33.26596, -118.44046 33.26746, -118.47146 33.27289, -118.50091 33.28407, -118.51039 33.28966, -118.53488 33.31518, -118.54252 33.33105, -118.54961 33.35065, -118.55119 33.36935, -118.54858 33.37503, -118.55338 33.38023, -118.56363 33.38103, -118.59108 33.39087, -118.61857 33.40619, -118.62592 33.41507, -118.63694 33.42868, -118.65506 33.44531, -118.66592 33.46733, -118.6682 33.48594, -118.66371 33.50003, -118.65992 33.50576, -118.65573 33.51082, -118.64786 33.51821, -118.6384 33.52403, -118.62592 33.52898, -118.61216 33.53185, -118.59976 33.53232, -118.58972 33.53198, -118.58582 33.53088, -118.57914 33.52841, -118.57529 33.52926, -118.57152 33.52947, -118.56719 33.52948, -118.56317 33.52929, -118.55775 33.52833, -118.55502 33.52921, -118.55093 33.53019, -118.5466 33.53084, -118.53894 33.53126, -118.53364 33.53144, -118.52938 33.53118, -118.52324 33.53015, -118.51765 33.52869, -118.51238 33.52692, -118.50676 33.52491, -118.50261 33.52267, -118.50091 33.52163, -118.49671 33.51838, -118.49333 33.51573, -118.48788 33.51615, -118.48262 33.51606, -118.47728 33.51543, -118.46896 33.513, -118.46285 33.51043, -118.45682 33.50688, -118.4522 33.50339, -118.44755 33.50003, -118.43683 33.48944, -118.43243 33.48894, -118.42709 33.48716, -118.42287 33.48387, -118.42084 33.48178, -118.41187 33.48078, -118.40323 33.47927, -118.39513 33.47671, -118.38939 33.47449, -118.38605 33.47345, -118.37798 33.47157, -118.37591 33.4711, -118.36922 33.469, -118.35939 33.46492, -118.35255 33.45938, -118.35092 33.45782, -118.34206 33.45388, -118.33277 33.44804, -118.32465 33.44198, -118.31635 33.43414, -118.31095 33.42514, -119.37595 34.06867, -119.33093 34.06506, -119.29764 34.03658, -119.29647 34.00001, -119.30409 33.98654, -119.34154 33.96543, -119.36976 33.95636, -119.38467 33.95332, -119.40293 33.95378, -119.43296 33.95591, -119.47265 33.97065, -119.49695 33.97634, -119.52331 33.95492, -119.56329 33.94496, -119.59594 33.93808, -119.61853 33.93588, -119.64054 33.93626, -119.66396 33.9264, -119.68239 33.91844, -119.71883 33.90963, -119.75096 33.9114, -119.77831 33.91061, -119.81022 33.90132, -119.85522 33.90749, -119.87823 33.92265, -119.90476 33.93967, -119.91102 33.9239, -119.95029 33.89438, -120.00096 33.88525, -120.01553 33.875, -120.04253 33.86432, -120.08011 33.85051, -120.12596 33.84235, -120.15708 33.85343, -120.183 33.86629, -120.20238 33.87598, -120.22963 33.89233, -120.25097 33.90844, -120.2777 33.94336, -120.29187 33.96224, -120.31739 33.96637, -120.35863 33.96139, -120.39564 33.96743, -120.42259 33.97495, -120.45579 33.97627, -120.48815 33.98428, -120.50308 33.99735, -120.52314 34.02282, -120.53106 34.05169, -120.56699 34.06864, -120.5819 34.09856, -120.57509 34.12647, -120.5487 34.14642, -120.50717 34.15134, -120.48691 34.14508, -120.46529 34.13929, -120.43272 34.15748, -120.40117 34.15873, -120.37598 34.15242, -120.35049 34.14145, -120.33918 34.12328, -120.32434 34.1138, -120.29779 34.10412, -120.27428 34.0818, -120.26241 34.06508, -120.25285 34.05803, -120.231 34.06114, -120.20611 34.06022, -120.1911 34.06136, -120.15901 34.0757, -120.13501 34.07881, -120.11496 34.07805, -120.10292 34.07449, -120.08028 34.0864, -120.04515 34.09061, -120.01021 34.08404, -119.99164 34.06487, -119.97439 34.09674, -119.96547 34.11256, -119.93615 34.12866, -119.90557 34.12935, -119.87988 34.12608, -119.86883 34.125, -119.83796 34.12019, -119.7926 34.10638, -119.76903 34.11194, -119.74522 34.11092, -119.71804 34.10175, -119.68607 34.09031, -119.65493 34.07122, -119.63523 34.08673, -119.62597 34.0927, -119.59056 34.10564, -119.57412 34.10811, -119.54825 34.10778, -119.52459 34.09871, -119.50095 34.08584, -119.47731 34.07183, -119.46004 34.06474, -119.42373 34.06769, -119.38975 34.06604, -119.62594 33.23455, -119.63128 33.24497, -119.63163 33.24891, -119.63154 33.25322, -119.63284 33.25902, -119.6363 33.27304, -119.63479 33.28596, -119.62908 33.29934, -119.62165 33.30925, -119.61453 33.3148, -119.60482 33.3204, -119.59252 33.32582, -119.58268 33.32779, -119.57491 33.32828, -119.56493 33.32764, -119.5546 33.33118, -119.54354 33.33416, -119.53418 33.33526, -119.52531 33.33486, -119.50855 33.331, -119.50094 33.32911, -119.49512 33.32715, -119.49054 33.32514, -119.4713 33.31683, -119.44327 33.30574, -119.43 33.30103, -119.42872 33.30033, -119.42816 33.30003, -119.42618 33.29894, -119.42594 33.29877, -119.4225 33.29623, -119.41337 33.28951, -119.40539 33.28351, -119.39991 33.28007, -119.39098 33.27438, -119.38522 33.27092, -119.37973 33.26763, -119.37594 33.26476, -119.37594 33.26324, -119.36908 33.25578, -119.36723 33.2534, -119.36472 33.25003, -119.36212 33.24522, -119.36093 33.24206, -119.36013 33.23487, -119.36018 33.22832, -119.3607 33.22145, -119.36244 33.21482, -119.3654 33.20851, -119.36845 33.2026, -119.37196 33.19763, -119.37386 33.19503, -119.37594 33.19219, -119.37899 33.19071, -119.38146 33.18948, -119.38614 33.18628, -119.39454 33.18084, -119.43372 33.16699, -119.44497 33.16527, -119.46836 33.16461, -119.47223 33.1644, -119.47526 33.16364, -119.47649 33.16349, -119.47874 33.16367, -119.47959 33.16391, -119.48944 33.1666, -119.49142 33.16701, -119.50094 33.16739, -119.50803 33.16739, -119.51025 33.16742, -119.512 33.16776, -119.51688 33.169, -119.52286 33.17089, -119.52671 33.17266, -119.52901 33.17325, -119.53224 33.17392, -119.54126 33.17647, -119.54676 33.17882, -119.55007 33.18028, -119.55154 33.18061, -119.55319 33.18126, -119.55495 33.18152, -119.56224 33.18248, -119.56932 33.18462, -119.57419 33.18648, -119.57832 33.1885, -119.58097 33.19019, -119.58726 33.19553, -119.58909 33.19673, -119.59395 33.199, -119.60026 33.20324, -119.60528 33.20692, -119.61147 33.21273, -119.61481 33.21725, -119.61824 33.22248, -119.61949 33.22501, -119.61992 33.22683, -119.62092 33.22786, -119.62192 33.22874, -119.62356 33.23041, -119.62519 33.23247, -114.63332 34.87057, -114.63305 34.86997, -114.56953 34.79181, -114.48236 34.71453, -114.44166 34.64288, -114.38169 34.47903, -114.29195 34.41527, -114.14737 34.31087, -114.26017 34.17212, -114.35765 34.12866, -114.4355 34.04257, -114.49813 33.96372, -114.51318 33.91285, -114.52801 33.84446, -114.49649 33.6969, -114.5402 33.58709, -114.61185 33.47131, -114.72123 33.39691, -114.68157 33.23376, -114.62973 33.03255, -114.48131 32.97206, -114.46563 32.87408, -114.58576 32.73487, -114.63501 32.73137, -114.69096 32.73946, -114.71919 32.71943, -114.71972 32.71875, -114.9559 32.70253, -115.47927 32.66605, -115.50314 32.66438, -115.80199 32.64163, -116.0738 32.6211, -116.19899 32.61112, -116.3481 32.59913, -116.46732 32.58952, -116.61646 32.57725, -116.75596 32.56578, -116.82902 32.55977, -116.95778 32.54863, -117.02945 32.54234, -117.06674 32.5395, -117.22314 32.6209, -117.30735 32.65404, -117.34004 32.83452, -117.37526 33.07321, -117.57153 33.3123, -117.71501 33.40862, -117.81636 33.49087, -117.94957 33.55979, -118.06299 33.63031, -118.34541 33.66343, -118.51367 33.93905, -118.62007 33.98697, -118.74596 33.97556, -118.87592 33.98382, -119.22693 34.07434, -119.33489 34.23687, -119.56331 34.34814, -119.73923 34.34275, -119.90542 34.36437, -120.12095 34.41671, -120.24944 34.41798, -120.42603 34.39674, -120.56388 34.4893, -120.6724 34.51999, -120.70856 34.60609, -120.683 34.7177, -120.68251 34.80895, -120.73438 34.9015, -120.6942 35.03457, -120.78292 35.11198, -120.96025 35.24362, -120.93094 35.37806, -121.05951 35.4377, -121.25103 35.60068, -121.4561 35.81771, -121.7489 36.14645, -121.86514 36.20183, -121.92971 36.25918, -121.96481 36.32734, -121.97196 36.37682, -121.98576 36.42509, -122.022 36.50891, -122.04406 36.58872, -122.06832 36.87495, -122.27637 37.02483, -122.4452 37.14967, -122.47161 37.31479, -122.56299 37.47338, -122.57267 37.62752, -122.63247 37.82781, -122.78903 37.89376, -122.89742 37.97575, -123.08461 37.98809, -123.12347 38.28431, -123.18504 38.40068, -123.3304 38.49991, -123.49508 38.66066, -123.7253 38.84412, -123.76207 39.03837, -123.80553 39.1249, -123.84839 39.21873, -123.89494 39.34835, -123.88889 39.44394, -123.83841 39.55492, -123.87391 39.68453, -123.9536 39.82699, -124.06357 39.95662, -124.2312 40.09338, -124.42868 40.27564, -124.47916 40.45264, -124.33411 40.71898, -124.1945 40.9617, -124.2151 41.03142, -124.24743 41.09222, -124.25119 41.13756, -124.21142 41.18092, -124.17435 41.25705, -124.19233 41.29199, -124.23454 41.31575, -124.23517 41.36383, -124.14406 41.38412, -124.15357 41.51075, -124.22986 41.6897, -124.41076 41.78831, -124.31194 41.85879, -124.32829 41.99807, -124.32883 41.99833, -124.11879 41.99703, -123.96782 41.99625, -123.79381 41.99569, -123.62007 41.99984, -123.51413 42.00086, -123.2737 42.00197, -123.03178 42.00302, -122.78389 42.00388, -122.64619 42.00482, -122.40756 42.00869, -122.18647 42.00755, -122.00032 42.00397, -121.81573 42.00262, -121.70538 42.00077, -121.6122 41.99933, -121.51946 41.99827, -121.43715 41.99738, -121.36025 41.99668, -121.26065 41.99759, -120.97395 41.99336, -120.76508 41.99387, -120.60306 41.99309, -120.30731 41.99313, -120.19996 41.99443, -120.00104 41.99514, -119.99917 41.99454, -119.99919 41.97905, -120.00002 41.26742, -119.99926 40.86934, -119.99567 40.39719, -119.99733 40.08934, -120.00049 39.79567, -120.0015 39.57782, -120.00608 39.37557, -119.9748 38.98156, -119.76041 38.83427, -119.43506 38.60904, -119.00097 38.30368, -118.51722 37.96065, -118.22972 37.75309, -118.04392 37.6185, -117.79563 37.43715, -117.31883 37.08441, -116.87227 36.75057, -116.37528 36.37205, -116.08072 36.14577, -115.89512 36.0018, -115.65233 35.81231, -115.36992 35.59033, -115.11622 35.38796, -114.82052 35.15341, -114.63361 35.00195, -114.63349 35.00186))"

        self.measure {

            do {
                let _ = try reader.read(string: wkt)
            } catch {
                XCTFail()
            }
        }
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class WKTReaderCoordinate2DMFloatingPrecisionCartesianTests: XCTestCase {

    private typealias WKTReaderType = WKTReader<Coordinate2DM>
    private var wktReader = WKTReaderType(precision: FloatingPrecision(), coordinateSystem: Cartesian())

    // MARK: Point

    func testReadPointValid() {

        let input = "POINT M (1.0 1.0 1.0)"
        let expected = Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate2DM>, expected)
    }

    func testReadPointInvalidCoordinateM() {

        let input = "POINT M (1.0 1.0 K)"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'numeric literal' but found -> 'K)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateMissingM() {

        let input = "POINT M (1.0 1.0 )"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'numeric literal' but found -> ')'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceAfterM() {

        let input = "POINT M(1.0 1.0 1.0)"
        let expected = "Unexpected token at line: 1 column: 8. Expected 'single space' but found -> '(1.0 1.0 1.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceBeforeM() {

        let input = "POINT M (1.0 1.01.0)"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'single space' but found -> '.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadInvalidNumberOfCoordinates() {

        let input = "POINT ZM (1.0 1.0 1.0 1.0)"
        let expected = "Invalid number of coordinates (4) supplied for type GeoFeatures.Coordinate2DM."

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in

            if case WKTReaderError.invalidNumberOfCoordinates(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    // MARK: - GoemetryCollection

    func testReadGeometryCollectionValid() {

        let input = "GEOMETRYCOLLECTION M (POINT M (1.0 1.0 1.0), LINESTRING M (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0))"
        let expected = GeometryCollection(elements:
            [
                Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0)),
                LineString<Coordinate2DM>(elements: [(x: 1.0, y: 1.0, m: 1.0), (x: 2.0, y: 2.0, m: 2.0), (x: 3.0, y: 3.0, m: 3.0)])
            ] as [Geometry])

        XCTAssertEqual(try wktReader.read(string: input) as? GeometryCollection, expected)
    }

    func testReadGeometryCollectionInvalidElementNoM() {

        let input = "GEOMETRYCOLLECTION M (POINT (1.0 1.0 1.0))"
        let expected = "Unexpected token at line: 1 column: 29. Expected 'M' but found -> '(1.0 1.0 1.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class WKTReaderCoordinate3DFloatingPrecisionCartesianTests: XCTestCase {

    private typealias WKTReaderType = WKTReader<Coordinate3D>
    private var wktReader = WKTReaderType(precision: FloatingPrecision(), coordinateSystem: Cartesian())

    // MARK: Point

    func testReadPointValid() {

        let input = "POINT Z (1.0 1.0 1.0)"
        let expected = Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate3D>, expected)
    }

    func testReadPointInvalidCoordinateZ() {

        let input = "POINT Z (1.0 1.0 K)"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'numeric literal' but found -> 'K)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateMissingZ() {

        let input = "POINT Z (1.0 1.0 )"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'numeric literal' but found -> ')'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceAfterZ() {

        let input = "POINT Z(1.0 1.01.0)"
        let expected = "Unexpected token at line: 1 column: 8. Expected 'single space' but found -> '(1.0 1.01.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceBeforeZ() {

        let input = "POINT Z (1.0 1.01.0)"
        let expected = "Unexpected token at line: 1 column: 18. Expected 'single space' but found -> '.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - GoemetryCollection

    func testReadGeometryCollectionValid() {

        let input = "GEOMETRYCOLLECTION Z (POINT Z (1.0 1.0 1.0), LINESTRING Z (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0))"
        let expected = GeometryCollection(elements:
            [
                Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0)),
                LineString<Coordinate3D>(elements: [(x: 1.0, y: 1.0, z: 1.0), (x: 2.0, y: 2.0, z: 2.0), (x: 3.0, y: 3.0, z: 3.0)])
            ] as [Geometry])

        XCTAssertEqual(try wktReader.read(string: input) as? GeometryCollection, expected)
    }

    func testReadGeometryCollectionInvalidElementNoZ() {

        let input = "GEOMETRYCOLLECTION Z (POINT (1.0 1.0 1.0))"
        let expected = "Unexpected token at line: 1 column: 29. Expected 'Z' but found -> '(1.0 1.0 1.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class WKTReaderCoordinate3DMFloatingPrecisionCartesianTests: XCTestCase {

    private typealias WKTReaderType = WKTReader<Coordinate3DM>
    private var wktReader = WKTReaderType(precision: FloatingPrecision(), coordinateSystem: Cartesian())

    // MARK: Point

    func testReadPointValid() {

        let input = "POINT ZM (1.0 1.0 1.0 1.0)"
        let expected = Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0))

        XCTAssertEqual(try wktReader.read(string: input) as? Point<Coordinate3DM>, expected)
    }

    func testReadPointInvalidCoordinateM() {

        let input = "POINT ZM (1.0 1.0 1.0 K)"
        let expected = "Unexpected token at line: 1 column: 23. Expected 'numeric literal' but found -> 'K)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateMissingM() {

        let input = "POINT ZM (1.0 1.0 1.0 )"
        let expected = "Unexpected token at line: 1 column: 23. Expected 'numeric literal' but found -> ')'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceAfterM() {

        let input = "POINT ZM(1.0 1.0 1.01.0)"
        let expected = "Unexpected token at line: 1 column: 9. Expected 'single space' but found -> '(1.0 1.0 1.01.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadPointInvalidCoordinateNoSpaceBeforeM() {

        let input = "POINT ZM (1.0 1.0 1.01.0)"
        let expected = "Unexpected token at line: 1 column: 23. Expected 'single space' but found -> '.0)'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    // MARK: - GoemetryCollection

    func testReadGeometryCollectionValid() {

        let input = "GEOMETRYCOLLECTION ZM (POINT ZM (1.0 1.0 1.0 1.0), LINESTRING ZM (1.0 1.0 1.0 1.0, 2.0 2.0 2.0 2.0, 3.0 3.0 3.0 3.0))"
        let expected = GeometryCollection(elements:
            [
                Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0)),
                LineString<Coordinate3DM>(elements: [(x: 1.0, y: 1.0, z: 1.0, m: 1.0), (x: 2.0, y: 2.0, z: 2.0, m: 2.0), (x: 3.0, y: 3.0, z: 3.0, m: 3.0)])
            ] as [Geometry])

        XCTAssertEqual(try wktReader.read(string: input) as? GeometryCollection, expected)
    }

    func testReadGeometryCollectionInvalidElementNoZ() {

        let input = "GEOMETRYCOLLECTION ZM (POINT M (1.0 1.0 1.0 1.0))"
        let expected = "Unexpected token at line: 1 column: 30. Expected 'Z' but found -> 'M (1.0 1.0 1.0 1.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testReadGeometryCollectionInvalidElementNoM() {

        let input = "GEOMETRYCOLLECTION ZM (POINT Z(1.0 1.0 1.0 1.0))"
        let expected = "Unexpected token at line: 1 column: 31. Expected 'M' but found -> '(1.0 1.0 1.0 1.0))'"

        XCTAssertThrowsError(try wktReader.read(string: input)) { error in
            if case WKTReaderError.unexpectedToken(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown")
            }
        }
    }
}
