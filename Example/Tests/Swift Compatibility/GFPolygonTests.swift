/*
 *   GFPolygonTests.swift
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

class GFPolygonTests: XCTestCase {

    func testInit_WKT_NoThrow () {
        XCTAssertEqual(try GFPolygon(wkt: "POLYGON((1 1,1 3,3 3,3 1,1 1))").toWKTString(), "POLYGON((1 1,1 3,3 3,3 1,1 1))")
    }
    
    func testInit_WKT_Throw () {
        XCTAssertThrowsError(try GFPolygon(wkt: "POLYGON INVALID"))
    }
    
    func testInit_GeoJSON_NoThrow () throws {
        XCTAssertEqual(try GFPolygon(geoJSONGeometry: ["type": "Polygon", "coordinates": [
        [
            [100.0, 0.0], [200.0, 100.0],[200.0, 0.0], [100.0, 1.0], [100.0, 0.0] ],
            [ [100.2, 0.2], [100.8, 0.2],  [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
        ]
            ]).toWKTString(), "POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))")
    }
    
    func testInit_GeoJSON_Throw () {
        XCTAssertThrowsError(try GFPolygon(geoJSONGeometry: ["type": "Invalid", "invalid": [[1.0, 1.0], [3.0, 3.0]]]))
    }
}
