/*
 *   GFMultiLineStringTests.swift
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
 *   Created by Tony Stone on 04/5/2015.
 */
import XCTest
import GeoFeatures

class GFMulitLineStringTests: XCTestCase {

    func testInit_WKT_NoThrow () {
        XCTAssertEqual(try GFMultiLineString(wkt: "MULTILINESTRING((100 0,101 1),(102 2,103 3))").toWKTString(), "MULTILINESTRING((100 0,101 1),(102 2,103 3))")
    }
    
    func testInit_WKT_Throw () {
        XCTAssertThrowsError(try GFMultiLineString(wkt: "MULTILINESTRING INVALID"))
    }
    
    func testInit_GeoJSON_NoThrow () throws {
        XCTAssertEqual(try GFMultiLineString(geoJSONGeometry: ["type": "MultiLineString", "coordinates": [[[100.0, 0.0],[101.0, 1.0]], [[102.0, 2.0],[103.0, 3.0]]]]).toWKTString(), "MULTILINESTRING((100 0,101 1),(102 2,103 3))")
    }
    
    func testInit_GeoJSON_Throw () {
        XCTAssertThrowsError(try GFMultiLineString(geoJSONGeometry: ["type": "Invalid", "invalid": [[[100.0, 0.0],[101.0, 1.0]], [[102.0, 2.0],[103.0, 3.0]]]]))
    }
}
