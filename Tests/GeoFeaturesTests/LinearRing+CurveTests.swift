/*
 *   LinearRing+CurveTests.swift
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
 *   Created by Tony Stone on 5/30/16.
 */
import XCTest

import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class LinearRing_Curve_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testLength_Test1() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 1, y: 1)], precision: precision, coordinateReferenceSystem: crs).length(), 1.4142135623730951)
    }
    
    func testLength_Test2() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2)], precision: precision, coordinateReferenceSystem: crs).length(), 2.0)
    }
    
    func testLength_Test3() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 7, y:0)], precision: precision, coordinateReferenceSystem: crs).length(), 7.0)
    }
    
    func testLength_Test4() {
        XCTAssertEqual(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 0, y: 4),(x: 0, y: 5)], precision: precision, coordinateReferenceSystem: crs).length(), 5.0)
    }
    
    func testLengthPerformance() {
        let lineString = LinearRing<Coordinate2D>(elements: [(x :0, y: 0),(x: 0, y: 2),(x: 0,y: 3),(x: 0, y: 4),(x: 0,y: 5)], precision: precision, coordinateReferenceSystem: crs)
        
        self.measure {
            
            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }
    
    func testIsClosed_Closed() {
        XCTAssertTrue(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 2, y: 0),(x: 0, y: 0)], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }

    func testIsClosed_Open() {
        XCTAssertFalse(LinearRing<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 0, y: 4),(x: 0, y: 5)], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
    
    func testIsClosed_Empty() {
        XCTAssertFalse(LinearRing<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
}

// MARK: - Coordinate3D, FloatingPrecision, Cartesian -

class LinearRing_Curve_Coordinate3D_FloatingPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testPerformanceLength() {
        let lineString = LinearRing<Coordinate3D>(elements: [(x :0, y: 0, z: 0),(x: 0, y: 2, z: 0),(x: 0,y: 3, z: 0),(x: 0, y: 4, z: 0),(x: 0,y: 5, z:0)], precision: precision, coordinateReferenceSystem: crs)
        
        self.measure {
            
            for _ in 1...500000 {
                let _ = lineString.length()
            }
        }
    }
}
