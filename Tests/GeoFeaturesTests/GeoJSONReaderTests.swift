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

    private typealias GeoJSONReaderType = GeoJSONReader<Coordinate2D>
    private var reader = GeoJSONReaderType(precision: FloatingPrecision(), coordinateReferenceSystem: Cartesian())

    // MARK: - Init

    func testRead_Point_Float_Valid() {

        let input = "{ 'type': 'Point', 'coordinates': [1.0, 1.0] }"
        let expected = Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0))

        XCTAssertEqual(try reader.read(json: input) as? Point<Coordinate2D>, expected)
    }

}
