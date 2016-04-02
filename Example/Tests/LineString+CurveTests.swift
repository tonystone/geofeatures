//
//  LengthTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 2/16/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class LineString_Curve_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    func testLength_Test1() {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 1, y: 1)]).length(), 1.4142135623730951)
    }

    func testLength_Test2() {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2)]).length(), 2.0)
    }

    func testLength_Test3() {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 7, y:0)]).length(), 7.0)
    }
    
    func testLength_Test4() {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 0, y: 4),(x: 0, y: 5)]).length(), 5.0)
    }

    func testPerformanceLength() {
        let lineString = LineString<Coordinate2D>(elements: [(x :0, y: 0),(x: 0, y: 2),(x: 0,y: 3),(x: 0, y: 4),(x: 0,y: 5)])
        
        self.measureBlock {
            
            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class LineString_Curve_Coordinate3D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    func testPerformanceLength() {
        let lineString = LineString<Coordinate3D>(elements: [(x :0, y: 0, z: 0),(x: 0, y: 2, z: 0),(x: 0,y: 3, z: 0),(x: 0, y: 4, z: 0),(x: 0,y: 5, z:0)])
        
        self.measureBlock {
            
            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }
}
