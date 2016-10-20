/*
 *   MultiLineString+CurveTests.swift
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
 *   Created by Tony Stone on 5/31/16.
 */
import XCTest

import GeoFeatures

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class MultiLineString_Curve_Coordinate2D_FloatingPrecision_Cartesian_Tests: XCTestCase {

    let precision = FloatingPrecision()
    let crs       = Cartesian()
    
    func testIsClosed_Closed() {
        XCTAssertTrue(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 2, y: 0),(x: 0, y: 0)], precision: precision, coordinateReferenceSystem: crs),
                LineString<Coordinate2D>(elements: [(x: 0, y: 1),(x: 0, y: 2),(x: 0, y: 3),(x: 2, y: 0),(x: 0, y: 1)], precision: precision, coordinateReferenceSystem: crs)
            ], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
    
    func testIsClosed_Open() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 0, y: 4),(x: 0, y: 5)], precision: precision, coordinateReferenceSystem: crs),
                LineString<Coordinate2D>(elements: [(x: 0, y: 0),(x: 0, y: 2),(x: 0, y: 3),(x: 0, y: 4),(x: 0, y: 5)], precision: precision, coordinateReferenceSystem: crs)
            ], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
    
    func testIsClosed_Empty() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
}

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiLineString_Curve_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {
    
    let precision = FixedPrecision(scale: 1000)
    let crs       = Cartesian()
    
    func testIsClosed_Closed() {
        XCTAssertTrue(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0),(x: 0.0, y: 2.002),(x: 0.0, y: 3.003),(x: 2.002, y: 0.0),(x: 0.0, y: 0.0)], precision: precision, coordinateReferenceSystem: crs),
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 1.001),(x: 0.0, y: 2.002),(x: 0.0, y: 3.003),(x: 2.002, y: 0.0),(x: 0.0, y: 1.001)], precision: precision, coordinateReferenceSystem: crs)
            ], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
    
    func testIsClosed_Open() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(elements:
            [
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0),(x: 0.0, y: 2.0),(x: 0.0, y: 3.003),(x: 0.0, y: 4.004),(x: 0.0, y: 5.001)], precision: precision, coordinateReferenceSystem: crs),
                LineString<Coordinate2D>(elements: [(x: 0.0, y: 0.0),(x: 0.0, y: 2.002),(x: 0.0, y: 3.003),(x: 0.0, y: 4.004),(x: 0.0, y: 5.001)], precision: precision, coordinateReferenceSystem: crs)
            ], precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
    
    func testIsClosed_Empty() {
        XCTAssertFalse(MultiLineString<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).isClosed())
    }
}
