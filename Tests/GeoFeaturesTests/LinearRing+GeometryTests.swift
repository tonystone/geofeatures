/*
 *   LinearRing+GeometryTests.swift
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

private let geometryDimension = Dimension.one    // LinearRing are always 1 dimension

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class LinearRing_Geometry_Coordinate2D_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension () {
        XCTAssertEqual(LinearRing<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }

    func testBoundary_1Element_Invalid() {
        let geometry = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0)], precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs) // Empty Set
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    func testBoundary_2Element() {
        let geometry = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0)], precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)),Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0))], precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    func testBoundary_3Element_Open() {
        let geometry = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0)], precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0)),Point<Coordinate2D>(coordinate: (x: 3.0, y: 3.0))], precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    func testBoundary_4Element_Closed() {
        let geometry = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0), (x: 2.0, y: 2.0), (x: 3.0, y: 3.0), (x: 1.0, y: 1.0)], precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs) // Empty Set
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
    
    func testBoundary_Empty() {
        let geometry = LineString<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).boundary()
        let expected = MultiPoint<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs)  // Empty Set
        
        XCTAssertTrue(geometry == expected, "\(geometry) is not equal to \(expected)")
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class LinearRing_Geometry_Coordinate2DM_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate2DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class LinearRing_Geometry_Coordinate3D_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate3D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class LinearRing_Geometry_Coordinate3DM_FloatingPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate3DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class LinearRing_Geometry_Coordinate2D_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class LinearRing_Geometry_Coordinate2DM_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate2DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class LinearRing_Geometry_Coordinate3D_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate3D>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class LinearRing_Geometry_Coordinate3DM_FixedPrecision_Cartesian_Tests : XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension ()   {
        XCTAssertEqual(LinearRing<Coordinate3DM>(precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
}
