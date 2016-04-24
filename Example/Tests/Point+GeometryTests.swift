//
//  Point+GeometryTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 4/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import GeoFeatures2

private let geometryDimension = 0   // Point always have a 0 dimension 

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class Point_Geometry_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class Point_Geometry_Coordinate2DM_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()

    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2DM>(coordinate: (x: 2.002, y: 2.002, m: 2.002), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class Point_Geometry_Coordinate3D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()

    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3D>(coordinate: (x: 2.0, y: 2.0, z: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class Point_Geometry_Coordinate3DM_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3DM>(coordinate: (x: 2.0, y: 2.0, z: 2.0, m: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class Point_Geometry_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2D>(coordinate: (x: 1.0, y: 1.0), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2D>(coordinate: (x: 2.0, y: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class Point_Geometry_Coordinate2DM_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }

    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2DM>(coordinate: (x: 1.0, y: 1.0, m: 1.0), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate2DM>(coordinate: (x: 2.0, y: 2.0, m: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class Point_Geometry_Coordinate3D_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }

    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3D>(coordinate: (x: 1.0, y: 1.0, z: 1.0), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3D>(coordinate: (x: 2.0, y: 2.0, z: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class Point_Geometry_Coordinate3DM_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testDimension() {
        XCTAssertEqual(Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs).dimension, geometryDimension)
    }
    
    func testIsEmpty() {
        XCTAssertEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs).isEmpty(), false)
    }
    
    func testEquals_IntOne_True() {
        XCTAssertEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3DM>(coordinate: (x: 1.0, y: 1.0, z: 1.0, m: 1.0), precision: precision, coordinateReferenceSystem: crs))
    }
    
    func testEquals_IntOne_False() {
        XCTAssertNotEqual(Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs), Point<Coordinate3DM>(coordinate: (x: 2.0, y: 2.0, z: 2.0, m: 2.0), precision: precision, coordinateReferenceSystem: crs))
    }
}
