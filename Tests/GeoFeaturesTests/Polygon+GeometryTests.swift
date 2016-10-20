/*
 *   Polygon+GeometryTests.swift
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
 *   Created by Tony Stone on 4/24/16.
 */
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

private let geometryDimension = Dimension.two    // Polygon are always 2 dimension

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class Polygon_Geometry_Coordinate2D_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testBoundary_OuterRing() {
        let geometry = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []), precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)]) ], precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    
    func testBoundary_OuterRing_1InnerRing() {
        let geometry = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [[(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)]]), precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)]), LineString<Coordinate2D>(elements: [(x: 5.0, y: 2.0), (x: 2.0, y: 2.0), (x: 2.0, y: 3.0), (x: 3.5, y: 3.5), (x: 5.0, y: 3.0)])], precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    func testBoundary_Empty() {
        let geometry = Polygon<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiLineString<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class Polygon_Geometry_Coordinate2DM_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate2DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class Polygon_Geometry_Coordinate3D_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate3D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class Polygon_Geometry_Coordinate3DM_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate3DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class Polygon_Geometry_Coordinate2D_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class Polygon_Geometry_Coordinate2DM_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate2DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class Polygon_Geometry_Coordinate3D_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate3D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class Polygon_Geometry_Coordinate3DM_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(Polygon<Coordinate3DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}
