/*
 *   GFGeometryCollectionTests.swift
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

class GFGeometryCollectionTests: XCTestCase {

    func testInit_WKT_NoThrow () {
        let wktString = "GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))"
        
        XCTAssertEqual(try GFGeometryCollection(wkt: wktString).toWKTString(), wktString)
    }
    
    func testInit_WKT_Throw () {
        XCTAssertThrowsError(try GFGeometryCollection(wkt: "GEOMETRYCOLLECTION INVALID"))
    }
    
    func testInit_GeoJSON_NoThrow () throws {
        let geometry1 = ["type": "Point", "coordinates": [100.0, 0.0]]
        let geometry2 = ["type": "LineString", "coordinates": [[100.0, 0.0],[101.0, 1.0]]]
        let geometry3 = ["type": "Polygon",
                         "coordinates": [
                            [ [100.0, 0.0], [200.0, 100.0],[200.0, 0.0], [100.0, 1.0], [100.0, 0.0] ],
                            [ [100.2, 0.2], [100.8, 0.2],  [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]]
        ]
        let geometry4 = ["type": "MultiPoint", "coordinates": [[100.0, 0.0],[101.0, 1.0]]]
        let geometry5 = ["type": "MultiLineString", "coordinates": [[[100.0, 0.0],[101.0, 1.0]], [[102.0, 2.0],[103.0, 3.0]]]]
        let geoJSON: [NSObject : AnyObject] =  [  "type": "GeometryCollection", "geometries": [ geometry1, geometry2, geometry3, geometry4, geometry5 ] ]
        
        XCTAssertEqual(try GFGeometryCollection(geoJSONGeometry: geoJSON).toWKTString(), "GEOMETRYCOLLECTION(POINT(100 0),LINESTRING(100 0,101 1),POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)),MULTIPOINT((100 0),(101 1)),MULTILINESTRING((100 0,101 1),(102 2,103 3)))")
    }
    
    func testInit_GeoJSON_Throw () {
        XCTAssertThrowsError(try GFGeometryCollection(geoJSONGeometry: ["type": "Invalid", "invalid": [[[100.0, 0.0],[101.0, 1.0]], [[102.0, 2.0],[103.0, 3.0]]]]))
    }
}
