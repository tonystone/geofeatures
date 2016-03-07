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
    
    func testRead_Point_InvalidCoordinate() {
        
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

    func testRead_MultiPoint_Valid() {

        do {
            let geometry1 = try WKTReader<Coordinate2D>.read("MULTIPOINT((1.0 2.0))")
            let geometry2 = try WKTReader<Coordinate2D>.read("MULTIPOINT((1.0 2.0), (10.0 20.0))")

            XCTAssertEqual(geometry1 == MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0))]), true)
            XCTAssertEqual(geometry2 == MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0)), Point<Coordinate2D>(coordinate: (x: 10.0, y: 20.0))]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_MultiPoint_Invalid() {
        
        do {
            // mising closing paren
            try WKTReader<Coordinate2D>.read("MULTIPOINT((1.0 2.0)")
        } catch let error {
            
            
            if case ParseError.UnexpectedToken(_) = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Parsing failed")
            }
        }
    }
}