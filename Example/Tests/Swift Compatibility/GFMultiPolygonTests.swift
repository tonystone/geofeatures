/*
 *   GFMultiPolygonTests.swift
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
 *   Created by Tony Stone on 04/8/2015.
 */
import XCTest
import GeoFeatures

class GFMultiPolygonTests: XCTestCase {

    func testInit_WKT_NoThrow () {
        XCTAssertEqual(try GFMultiPolygon(wkt: "MULTIPOLYGON(((102 2,102 3,103 3,103 2,102 2)),((100 0,101 1,100 1,101 0,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)))").toWKTString(), "MULTIPOLYGON(((102 2,102 3,103 3,103 2,102 2)),((100 0,101 1,100 1,101 0,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)))")
    }
    
    func testInit_WKT_Throw () {
        XCTAssertThrowsError(try GFMultiPolygon(wkt: "MULTILINESTRING INVALID"))
    }
    
    func testInit_GeoJSON_NoThrow () throws {
        let geoJSON = [
            "type": "MultiPolygon",
            "coordinates": [
                [
                    [[102.0, 2.0], [102.0, 3.0], [103.0, 3.0], [103.0, 2.0], [102.0, 2.0]]
                ],
                [
                    [[100.0, 0.0], [101.0, 1.0], [100.0, 1.0], [101.0, 0.0], [100.0, 0.0]],
                    [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
                ]
            ]
        ] as [String : Any]
        XCTAssertEqual(try GFMultiPolygon(geoJSONGeometry: geoJSON).toWKTString(), "MULTIPOLYGON(((102 2,102 3,103 3,103 2,102 2)),((100 0,101 1,100 1,101 0,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)))")
    }
    
    func testInit_GeoJSON_Throw () {
        XCTAssertThrowsError(try GFMultiPolygon(geoJSONGeometry: ["type": "Invalid", "invalid": [[[100.0, 0.0],[101.0, 1.0]], [[102.0, 2.0],[103.0, 3.0]]]]))
    }
}
