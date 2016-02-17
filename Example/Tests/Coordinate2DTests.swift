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
    
    // MARK: Equal
    
    func testEqual_Zero()         { XCTAssertTrue(coordinateEquals((0.0,0.0), (0.0,0.0))) }
    
    func testEqual_One()          { XCTAssertTrue(coordinateEquals((1.0,1.0), (1.0,1.0)))  }
    
    func testEqual_Negative()     { XCTAssertTrue(coordinateEquals((-1.0,-1.0), (-1.0,-1.0))) }
    
    func testEqual_Small()        { XCTAssertTrue(coordinateEquals((0.0000000000000000001,0.0000000000000000001), (0.0000000000000000001,0.0000000000000000001))) }
    
    func testEqual_Large()        { XCTAssertTrue(coordinateEquals((1000000000000000000.0,1000000000000000000.0), (1000000000000000000.0,1000000000000000000.0)))  }
    
    // MARK: Not Equal
    
    func testNotEqual_Zero()         { XCTAssertFalse(coordinateEquals((0.0,0.0),(1.0,0.0))) }
    
    func testNotEqual_One()          { XCTAssertFalse(coordinateEquals((1.0,1.0),(0.0,1.0)))  }
    
    func testNotEqual_Negative()     { XCTAssertFalse(coordinateEquals((-1.0,-1.0),(-2.0,-1.0)))  }
    
    func testNotEqual_Small()        { XCTAssertFalse(coordinateEquals((0.0000000000000000001,0.0000000000000000001), (0.00000000000000000011,0.0000000000000000001)))  }
    
    func testNotEqual_Large()        { XCTAssertFalse(coordinateEquals((1000000000000000000.0,1000000000000000000.0), (1200000000000000000.0,1000000000000000000.0)))  }
    
}


