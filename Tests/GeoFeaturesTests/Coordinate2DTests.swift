/*
 *   Coordinate2DTests.swift
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

class Coordinate2DTests: XCTestCase {
    
    // MARK: Coordinate2D
    
    func testInit_XY () {
        let coordinate = Coordinate2D(x: 2.0, y: 3.0)
        
        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
    }
    
    func testX () {
        XCTAssertEqual(Coordinate2D(x: 1001.0, y: 1002.0).x, 1001.0)
    }
    
    func testY () {
        XCTAssertEqual(Coordinate2D(x: 1001.0, y: 1002.0).y, 1002.0)
    }
    
    // MARK: TupleConvertable
    
    func testInit_Tuple () {
        let coordinate = Coordinate2D(tuple: (x: 2.0, y: 3.0))
        
        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
    }
    
    func testTuple () {
        let coordinate = Coordinate2D(tuple: (x: 2.0, y: 3.0))
        let expected   = (x: 2.0, y: 3.0)
        
        XCTAssertTrue(coordinate.tuple == expected, "\(coordinate.tuple) is not equal to \(expected)")
    }
    
    
    // MARK: _ArrayConstructable
    
    func testInit_Array () {
        let coordinate = Coordinate2D(array: [2.0, 3.0])
        
        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
    }
    
    func testInit_Array_Invalid () {
        // TODO: Can't test precondition at this point due to lack of official support in Swift.
    }
    
    // MARK: CopyConstructable
    
    func testInit_Copy () {
        let coordinate = Coordinate2D(other: Coordinate2D(x: 2.0, y: 3.0))
        
        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
    }
    
    func testInit_Copy_FixedPrecision () {
        let coordinate = Coordinate2D(other: Coordinate2D(x: 2.002, y: 3.003), precision: FixedPrecision(scale: 100))
        
        XCTAssertEqual(coordinate.x, 2.0)
        XCTAssertEqual(coordinate.y, 3.0)
    }
    
    // MARK: Equal
    
    func testEqual () {
        XCTAssertEqual(Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 1.0, y: 1.0)))
    }
 
    func testNotEqual () {
        XCTAssertNotEqual(Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0)))
    }
}


