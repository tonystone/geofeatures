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
    
    func test3DInit() {
        let point = Point(coordinate: (1.0,1.0,1.0))
        
        XCTAssertEqual(point.x == 1.0 && point.y == 1.0 && point.z == 1.0, true)
    }
    
    // MARK: Equal
    
    func test3DEquals_IntZero() { XCTAssertEqual(Point(coordinate: (0,0,0)) == Point(coordinate: (0,0,0)), true) }
    
    func test2DEquals_IntZero() { XCTAssertEqual(Point(coordinate: (0,0)) == Point(coordinate: (0,0,Double.NaN)), true) }
    
    // MARK: isEmpty
    
    func testIsEmpty() {  XCTAssertEqual(Point(coordinate: (1,1)).isEmpty(), false)  }
}


