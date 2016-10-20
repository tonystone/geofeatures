/*
 *   PointTests.swift
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
 *   Created by Tony Stone on 2/10/16.
 */
import XCTest

import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class Point_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.001)
        XCTAssertEqual(point.y, 1.001)
    }
}

// MARK: - Coordinate2DM, FloatingPrecision, Cartesian -

class Point_Coordinate2DM_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.001)
        XCTAssertEqual(point.y, 1.001)
        XCTAssertEqual(point.m, 1.001)
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class Point_Coordinate3D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.001)
        XCTAssertEqual(point.y, 1.001)
        XCTAssertEqual(point.z, 1.001)
    }
}

// MARK: - Coordinate3DM, FloatingPrecision, Cartesian -

class Point_Coordinate3DM_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.001)
        XCTAssertEqual(point.y, 1.001)
        XCTAssertEqual(point.z, 1.001)
        XCTAssertEqual(point.m, 1.001)
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class Point_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate2D>(coordinate: (x: 1.001, y: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.0)
        XCTAssertEqual(point.y, 1.0)
    }
}

// MARK: - Coordinate2DM, FixedPrecision, Cartesian -

class Point_Coordinate2DM_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate2DM>(coordinate: (x: 1.001, y: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.0)
        XCTAssertEqual(point.y, 1.0)
        XCTAssertEqual(point.m, 1.0)
    }
}

// MARK: - Coordinate3D, FixedPrecision, Cartesian -

class Point_Coordinate3D_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate3D>(coordinate: (x: 1.001, y: 1.001, z: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.0)
        XCTAssertEqual(point.y, 1.0)
        XCTAssertEqual(point.z, 1.0)
    }
}

// MARK: - Coordinate3DM, FixedPrecision, Cartesian -

class Point_Coordinate3DM_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 100)
    let crs       = Cartesian()
    
    func testInit() {
        let point = Point<Coordinate3DM>(coordinate: (x: 1.001, y: 1.001, z: 1.001, m: 1.001), precision: precision, coordinateReferenceSystem: crs)
        
        XCTAssertEqual(point.x, 1.0)
        XCTAssertEqual(point.y, 1.0)
        XCTAssertEqual(point.z, 1.0)
        XCTAssertEqual(point.m, 1.0)
    }
}
