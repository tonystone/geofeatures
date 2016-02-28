/*
 *   Coordinate3DTests.swift
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
@testable import GeoFeatures2

class Coordinate2DTests: XCTestCase {
    
    
    // MARK: Contrsuction 
    
    func testInit () {
        let coordinate = Coordinate2D(tuple: (2.0,3.0))
        
        XCTAssertTrue(coordinate.x == 2.0 && coordinate.y == 3.0)
    }
    
    // MARK: Accessors
    
    func testTuple () {
        let coordinate = Coordinate2D(tuple: (2.0,3.0))
        
        XCTAssertTrue(coordinate.tuple.x == 2.0 && coordinate.tuple.y == 3.0)
    }
    
    func testX () {
        XCTAssertEqual(Coordinate2D(tuple: (1001.0,1002.0)).x, 1001.0)
    }
    
    func testY () {
        XCTAssertEqual(Coordinate2D(tuple: (1001.0,1002.0)).y, 1002.0)
    }
    
    // MARK: Hashvalue
    
    func testHasvalue_Equal_Values0_0() {
        XCTAssertEqual(Coordinate2D(tuple: (0.0,0.0)).hashValue, Coordinate2D(tuple: (0.0,0.0)).hashValue)
    }
    
    func testHasvalue_Equal_Values1_1 () {
        XCTAssertEqual(Coordinate2D(tuple: (1.0,1.0)).hashValue, Coordinate2D(tuple: (1.0,1.0)).hashValue)
    }
    
    func testHasvalue_Equal_Values1_2 () {
        XCTAssertEqual(Coordinate2D(tuple: (1.0,2.0)).hashValue, Coordinate2D(tuple: (1.0,2.0)).hashValue)
    }
    
    func testHasvalue_Equal_Values1234_1234 () {
        XCTAssertEqual(Coordinate2D(tuple: (1234.0,1234.0)).hashValue, Coordinate2D(tuple: (1234.0,1234.0)).hashValue)
    }
    
    func testHasvalue_NotEqual_Values0_0_Values1_1 () {
        XCTAssertNotEqual(Coordinate2D(tuple: (0.0,0.0)).hashValue, Coordinate2D(tuple: (1.0,1.0)).hashValue)
    }
    
    func testHasvalue_NotEqual_Values0_0_Value2_0 () {
        XCTAssertNotEqual(Coordinate2D(tuple: (0.0,0.0)).hashValue, Coordinate2D(tuple: (2.0,0.0)).hashValue)
    }
    
    func testHasvalue_NotEqual_Values1_1_Values3_3 () {
        XCTAssertNotEqual(Coordinate2D(tuple: (1.0,1.0)).hashValue, Coordinate2D(tuple: (3.0,3.0)).hashValue)
    }
    
    func testHasvalue_NotEqual_Values1_2_Values3_4 () {
        XCTAssertNotEqual(Coordinate2D(tuple: (1.0,2.0)).hashValue, Coordinate2D(tuple: (3.0,4.0)).hashValue)
    }
    
    func testHasvalue_NotEqual_Values1234_1234_Values12345_12345 () {
        XCTAssertNotEqual(Coordinate2D(tuple: (1234.0,1234.0)).hashValue, Coordinate2D(tuple: (12345.0,12345.0)).hashValue)
    }
    
    // MARK: Equal
    
    func testEqual () {
        XCTAssertEqual(Coordinate2D(tuple: (1.0,1.0)), Coordinate2D(tuple: (1.0,1.0)))
    }
 
    func testNotEqual () {
        XCTAssertNotEqual(Coordinate2D(tuple: (1.0,1.0)), Coordinate2D(tuple: (2.0,2.0)))
    }
    
}


