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
import UIKit
import XCTest
@testable import GeoFeatures2

class PointTests: XCTestCase {
    
    // MARK: Init
    func testInit_2D() {
        let point = Point<Coordinate2D>(coordinate: (1.0,1.0))
        
        XCTAssertEqual(point.x == 1.0 && point.y == 1.0, true)
    }
    
    func testInit_2DMeasured() {
        let point = Point<Coordinate2DM>(coordinate: (1.0,1.0,1.0))
        
        XCTAssertEqual(point.x == 1.0 && point.y == 1.0 && point.m == 1.0, true)
    }
    
    func testInit_3D() {
        let point = Point<Coordinate3D>(coordinate: (1.0,1.0,1.0))
        
        XCTAssertEqual(point.x == 1.0 && point.y == 1.0 && point.z == 1.0, true)
    }
    
    func testInit_3DMeasured() {
        let point = Point<Coordinate3DM>(coordinate: (1.0,1.0,1.0,1.0))
        
        XCTAssertEqual(point.x == 1.0 && point.y == 1.0 && point.z == 1.0 && point.m == 1.0, true)
    }
    
    // MARK: Equal
    
    func test3DEquals_IntZero_True()    { XCTAssertEqual(Point<Coordinate3D>(coordinate: (0,0,0)) == Point<Coordinate3D>(coordinate: (0,0,0)), true) }
    
    func test3DEquals_IntOne_False()    { XCTAssertEqual(Point<Coordinate3D>(coordinate: (1,1,1)) == Point<Coordinate3D>(coordinate: (2,2,2)), false) }
    
    func test2DEquals_IntOne_True()     { XCTAssertEqual(Point<Coordinate2D>(coordinate: (1,1)) == Point<Coordinate2D>(coordinate: (1,1)), true) }
    
    func test2DEquals_IntOne_False()    { XCTAssertEqual(Point<Coordinate2D>(coordinate: (1,1)) == Point<Coordinate2D>(coordinate: (2,2)), false) }
    
    func test2DEquals3D_IntOne_False () { XCTAssertEqual(Point<Coordinate2D>(coordinate: (1,1)) == Point<Coordinate3D>(coordinate: (1,1,Double.NaN)), false) }
    
    // MARK: isEmpty
    
    func testIsEmpty() {  XCTAssertEqual(Point<Coordinate2D>(coordinate: (1,1)).isEmpty(), false)  }
}


