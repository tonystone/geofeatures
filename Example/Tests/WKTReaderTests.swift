/*
*   WKTReaderTests
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
import GeoFeatures2

class WKTReaderTests: XCTestCase {

    func testRead_Point_Valid() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read("POINT(1.0 1.0)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0, 1.0)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Valid_WhiteSpace() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read(" POINT  (   1.0     1.0   ) ")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0, 1.0)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Valid_Exponent_UpperCase() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read("POINT(1.0E-5 1.0E-5)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0E-5, 1.0E-5)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Valid_Exponent_LowerCase() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read("POINT(1.0e-5 1.0e-5)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0E-5, 1.0E-5)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Invalid1() {
        
        do {
            try WKTReader<Coordinate2D>.read("POINT(1.01.0)")
            
            XCTFail("Parsing failed: Point should not have parsed.")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testRead_LineString_Valid() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read("LINESTRING(1.0 1.0, 2.0 2.0, 3.0 3.0)")
            
            XCTAssertEqual(geometry == LineString<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
}
