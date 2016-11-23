//
//  GeoJSONReaderTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 11/16/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class GeoJSONReader_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    private typealias CoordinateType = Coordinate2D
    private typealias GeoJSONReaderType = GeoJSONReader<CoordinateType>

    private var reader = GeoJSONReaderType(precision: FloatingPrecision(), coordinateSystem: Cartesian())

    // MARK: - Negative Tests

    func testReadWithInvalidJSON() {

        let input = ":&*** This is not JSON"
        let expected = "The data couldn’t be read because it isn’t in the correct format."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidJSON(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithInvalidRoot() {

        let input = "[]"
        let expected = "Root JSON must be an object type."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidJSON(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithMissingTypeAttribute() {

        let input = "{  \"coordinates\": [1.0, 1.0] }"
        let expected = "Missing required attribute \"type\"."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.missingAttribute(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithUnsupportedType() {

        let input = "{ \"type\": \"Polywoggle\", \"coordinates\": [1.0, 1.0] }"
        let expected = "Unsupported type \"Polywoggle\"."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.unsupportedType(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithMissingCoordinates() {

        let input = "{ \"type\": \"Point\" }"
        let expected = "Missing required attribute \"coordinates\"."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.missingAttribute(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithInvalidCoordinateStructure() {

        let input = "{ \"type\": \"Point\", \"coordinates\": [[1.0, 1.0]] }"
        let expected = "Invalid structure for \"coordinates\" attribute."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidJSON(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithInvalidNumberOfCoordinates() {

        let input = "{ \"type\": \"Point\", \"coordinates\": [1.0, 1.0, 1.0, 1.0] }"
        let expected = "Invalid number of coordinates (4) supplied for type GeoFeatures.Coordinate2D."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidNumberOfCoordinates(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithMissingGeometries() {

        let input = "{ \"type\": \"GeometryCollection\" }"
        let expected = "Missing required attribute \"geometries\"."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.missingAttribute(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    func testReadWithInvalidGeometriesStructure() {

        let input = "{ \"type\": \"GeometryCollection\", \"geometries\": {} }"
        let expected = "Invalid structure for \"geometries\" attribute."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidJSON(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    // MARK: Positive Tests

    func testReadWithValidPoint() {

        let input = "{ \"type\": \"Point\", \"coordinates\": [1.0, 1.0] }"
        let expected = Point<CoordinateType>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try reader.read(string: input) as? Point<CoordinateType>, expected)
    }

    func testReadWithValidLineString() {

        let input = "{ \"type\": \"LineString\", \"coordinates\": [ [1.0, 1.0], [2.0, 2.0] ] }"
        let expected = LineString<CoordinateType>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)])

        XCTAssertEqual(try reader.read(string: input) as? LineString<CoordinateType>, expected)
    }

    func testReadWithValidPolygon() {

        let input = "{ \"type\": \"Polygon\"," +
                        "\"coordinates\": [" +
                        "[ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]," +
                        "[ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]" +
                        "]" +
                    "}"
        let expected = Polygon<CoordinateType>(rings: ([(x: 100.0, y: 0.0), (x: 101.0, y: 0.0), (x: 101.0, y: 1.0), (x: 100.0, y: 1.0), (x: 100.0, y: 0.0)], [[(x: 100.2, y: 0.2), (x: 100.8, y: 0.2), (x: 100.8, y: 0.8), (x: 100.2, y: 0.8), (x: 100.2, y: 0.2)]]))

        XCTAssertEqual(try reader.read(string: input) as? Polygon<CoordinateType>, expected)
    }

    func testReadWithValidMultiPoint() {

        let input = "{ \"type\": \"MultiPoint\", \"coordinates\": [ [100.0, 0.0], [101.0, 1.0] ] }"
        let expected = MultiPoint<CoordinateType>(elements: [Point<CoordinateType>(coordinate: (x: 100.0, y: 0.0)), Point<CoordinateType>(coordinate: (x: 101.0, y: 1.0))])

        XCTAssertEqual(try reader.read(string: input) as? MultiPoint<CoordinateType>, expected)
    }

    func testReadWithValidMultiLineString() {

        let input = "{ \"type\": \"MultiLineString\"," +
                       "\"coordinates\": [" +
                            "[ [100.0, 0.0], [101.0, 1.0] ]," +
                            "[ [102.0, 2.0], [103.0, 3.0] ]" +
                        "]" +
                    "}"
        let expected = MultiLineString<CoordinateType>(elements: [LineString<CoordinateType>(elements: [(x: 100.0, y: 0.0), (x: 101.0, y: 1.0)]), LineString<CoordinateType>(elements: [(x: 102.0, y: 2.0), (x: 103.0, y: 3.0)])])

        XCTAssertEqual(try reader.read(string: input) as? MultiLineString<CoordinateType>, expected)
    }

    func testReadWithValidMultiPolygon() {

        let input = "{ \"type\": \"MultiPolygon\"," +
                        "\"coordinates\": [" +
                            "[[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]]," +
                            "[[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]]," +
                            " [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]" +
                        "]" +
                    "}"
        let expected = MultiPolygon<CoordinateType>(elements: [
                Polygon<CoordinateType>(rings: ([(x: 102.0, y: 2.0), (x: 103.0, y: 2.0), (x: 103.0, y: 3.0), (x: 102.0, y: 3.0), (x: 102.0, y: 2.0)], [])),
                Polygon<CoordinateType>(rings: ([(x: 100.0, y: 0.0), (x: 101.0, y: 0.0), (x: 101.0, y: 1.0), (x: 100.0, y: 1.0), (x: 100.0, y: 0.0)], [[(x: 100.2, y: 0.2), (x: 100.8, y: 0.2), (x: 100.8, y: 0.8), (x: 100.2, y: 0.8), (x: 100.2, y: 0.2)]]))
                ])

        XCTAssertEqual(try reader.read(string: input) as? MultiPolygon<CoordinateType>, expected)
    }

    func testReadWithValidGeometryCollection() {

        let input = "{ \"type\": \"GeometryCollection\"," +
                        "\"geometries\": [" +
                            "{ \"type\": \"Point\", \"coordinates\": [100.0, 0.0] }," +
                            "{ \"type\": \"LineString\", \"coordinates\": [ [101.0, 0.0], [102.0, 1.0] ] }" +
                        "]" +
                    "}"
        let expected = GeometryCollection(elements: [
                Point<CoordinateType>(coordinate: (x: 100.0, y: 0.0)),
                LineString<CoordinateType>(elements: [(x: 101.0, y: 0.0), (x: 102.0, y: 1.0)])
                ] as [Geometry])

        XCTAssertEqual(try reader.read(string: input) as? GeometryCollection, expected)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class GeoJSONReader_Coordinate3DM_FixedPrecision_Cartesian_Tests: XCTestCase {

    private typealias CoordinateType = Coordinate3DM
    private typealias GeoJSONReaderType = GeoJSONReader<CoordinateType>

    private var reader = GeoJSONReaderType(precision: FixedPrecision(scale: 100), coordinateSystem: Cartesian())

    // MARK: negative Tests

    func testReadWithInvalidNumberOfCoordinates() {

        let input = "{ \"type\": \"Point\", \"coordinates\": [1.0, 1.0, 1.0] }"
        let expected = "Invalid number of coordinates (3) supplied for type GeoFeatures.Coordinate3DM."

        XCTAssertThrowsError(try reader.read(string: input)) { error in

            if case GeoJSONReaderError.invalidNumberOfCoordinates(let message) = error {
                XCTAssertEqual(message, expected)
            } else {
                XCTFail("Wrong error thrown: \(error) is not equal to \(expected)")
            }
        }
    }

    // MARK: Positive Tests

    func testReadWithValidPoint() {

        let input = "{ \"type\": \"Point\", \"coordinates\": [1.001, 1.001, 1.001, 1.001] }"
        let expected = Point<CoordinateType>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0))

        XCTAssertEqual(try reader.read(string: input) as? Point<CoordinateType>, expected)
    }

    func testReadWithValidLineString() {

        let input = "{ \"type\": \"LineString\", \"coordinates\": [ [1.0, 1.0, 1.0, 1.0], [2.0, 2.0, 2.0, 2.0] ] }"
        let expected = LineString<CoordinateType>(elements: [(x: 1.0, y: 1.0, z: 1.0, m: 1.0), (x: 2.0, y: 2.0, z: 2.0, m: 2.0)])

        XCTAssertEqual(try reader.read(string: input) as? LineString<CoordinateType>, expected)
    }

    func testReadWithValidPolygon() {

        let input = "{ \"type\": \"Polygon\"," +
                        "\"coordinates\": [" +
                        "[ [100.0, 0.0, 1.0, 1.0], [101.0, 0.0, 1.0, 1.0], [101.0, 1.001, 1.0, 1.0], [100.0, 1.001, 1.0, 1.0], [100.0, 0.0, 1.0, 1.0] ]," +
                        "[ [100.2, 0.2, 1.0, 1.0], [100.8, 0.2, 1.0, 1.0], [100.8, 0.8, 1.0, 1.0], [100.2, 0.8, 1.0, 1.0], [100.2, 0.2, 1.0, 1.0] ]" +
                        "]" +
                    "}"
        let expected = Polygon<CoordinateType>(rings: ([(x: 100.0, y: 0.0, z: 1.0, m: 1.0), (x: 101.0, y: 0.0, z: 1.0, m: 1.0), (x: 101.0, y: 1.0, z: 1.0, m: 1.0), (x: 100.0, y: 1.0, z: 1.0, m: 1.0), (x: 100.0, y: 0.0, z: 1.0, m: 1.0)], [[(x: 100.2, y: 0.2, z: 1.0, m: 1.0), (x: 100.8, y: 0.2, z: 1.0, m: 1.0), (x: 100.8, y: 0.8, z: 1.0, m: 1.0), (x: 100.2, y: 0.8, z: 1.0, m: 1.0), (x: 100.2, y: 0.2, z: 1.0, m: 1.0)]]))

        XCTAssertEqual(try reader.read(string: input) as? Polygon<CoordinateType>, expected)
    }

    func testReadWithValidMultiPoint() {

        let input = "{ \"type\": \"MultiPoint\", \"coordinates\": [ [100.0, 0.0, 1.0, 1.0], [101.0, 1.0, 1.0, 1.0] ] }"
        let expected = MultiPoint<CoordinateType>(elements: [Point<CoordinateType>(coordinate: (x: 100.0, y: 0.0, z: 1.0, m: 1.0)), Point<CoordinateType>(coordinate: (x: 101.0, y: 1.0, z: 1.0, m: 1.0))])

        XCTAssertEqual(try reader.read(string: input) as? MultiPoint<CoordinateType>, expected)
    }

    func testReadWithValidMultiLineString() {

        let input = "{ \"type\": \"MultiLineString\"," +
                       "\"coordinates\": [" +
                            "[ [100.0, 0.0, 1.0, 1.0], [101.0, 1.0, 1.0, 1.0] ]," +
                            "[ [102.0, 2.0, 1.0, 1.0], [103.0, 3.0, 1.0, 1.0] ]" +
                        "]" +
                    "}"
        let expected = MultiLineString<CoordinateType>(elements: [LineString<CoordinateType>(elements: [(x: 100.0, y: 0.0, z: 1.0, m: 1.0), (x: 101.0, y: 1.0, z: 1.0, m: 1.0)]), LineString<CoordinateType>(elements: [(x: 102.0, y: 2.0, z: 1.0, m: 1.0), (x: 103.0, y: 3.0, z: 1.0, m: 1.0)])])

        XCTAssertEqual(try reader.read(string: input) as? MultiLineString<CoordinateType>, expected)
    }

    func testReadWithValidMultiPolygon() {

        let input = "{ \"type\": \"MultiPolygon\"," +
                        "\"coordinates\": [" +
                            "[[[102.0, 2.0, 1.0, 1.0], [103.0, 2.0, 1.0, 1.0], [103.0, 3.0, 1.0, 1.0], [102.0, 3.0, 1.0, 1.0], [102.0, 2.0, 1.0, 1.0]]]," +
                            "[[[100.0, 0.0, 1.0, 1.0], [101.0, 0.0, 1.0, 1.0], [101.0, 1.0, 1.0, 1.0], [100.0, 1.0, 1.0, 1.0], [100.0, 0.0, 1.0, 1.0]]," +
                            " [[100.2, 0.2, 1.0, 1.0], [100.8, 0.2, 1.0, 1.0], [100.8, 0.8, 1.0, 1.0], [100.2, 0.8, 1.0, 1.0], [100.2, 0.2, 1.0, 1.0]]]" +
                        "]" +
                    "}"
        let expected = MultiPolygon<CoordinateType>(elements: [
                Polygon<CoordinateType>(rings: ([(x: 102.0, y: 2.0, z: 1.0, m: 1.0), (x: 103.0, y: 2.0, z: 1.0, m: 1.0), (x: 103.0, y: 3.0, z: 1.0, m: 1.0), (x: 102.0, y: 3.0, z: 1.0, m: 1.0), (x: 102.0, y: 2.0, z: 1.0, m: 1.0)], [])),
                Polygon<CoordinateType>(rings: ([(x: 100.0, y: 0.0, z: 1.0, m: 1.0), (x: 101.0, y: 0.0, z: 1.0, m: 1.0), (x: 101.0, y: 1.0, z: 1.0, m: 1.0), (x: 100.0, y: 1.0, z: 1.0, m: 1.0), (x: 100.0, y: 0.0, z: 1.0, m: 1.0)], [[(x: 100.2, y: 0.2, z: 1.0, m: 1.0), (x: 100.8, y: 0.2, z: 1.0, m: 1.0), (x: 100.8, y: 0.8, z: 1.0, m: 1.0), (x: 100.2, y: 0.8, z: 1.0, m: 1.0), (x: 100.2, y: 0.2, z: 1.0, m: 1.0)]]))
                ])

        XCTAssertEqual(try reader.read(string: input) as? MultiPolygon<CoordinateType>, expected)
    }

    func testReadWithValidGeometryCollection() {

        let input = "{ \"type\": \"GeometryCollection\"," +
                        "\"geometries\": [" +
                            "{ \"type\": \"Point\", \"coordinates\": [100.0, 0.0, 1.0, 1.0] }," +
                            "{ \"type\": \"LineString\", \"coordinates\": [ [101.0, 0.0, 1.0, 1.0], [102.0, 1.0, 1.0, 1.0] ] }" +
                        "]" +
                    "}"
        let expected = GeometryCollection(elements: [
                Point<CoordinateType>(coordinate: (x: 100.0, y: 0.0, z: 1.0, m: 1.0)),
                LineString<CoordinateType>(elements: [(x: 101.0, y: 0.0, z: 1.0, m: 1.0), (x: 102.0, y: 1.0, z: 1.0, m: 1.0)])
                ] as [Geometry])

        XCTAssertEqual(try reader.read(string: input) as? GeometryCollection, expected)
    }

}
