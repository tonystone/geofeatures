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
 *   Created by Paul Chang on 3/9/16.
 */

import XCTest
import GeoFeatures2

class WKTWriterTests: XCTestCase {
    
    var wktWriter2D  : WKTWriter<Coordinate2D>!
    var wktWriter2DM : WKTWriter<Coordinate2DM>!
    var wktWriter3D  : WKTWriter<Coordinate3D>!
    var wktWriter3DM : WKTWriter<Coordinate3DM>!
    
    override func setUp() {
        wktWriter2D  = WKTWriter<Coordinate2D>()
        wktWriter2DM = WKTWriter<Coordinate2DM>()
        wktWriter3D  = WKTWriter<Coordinate3D>()
        wktWriter3DM = WKTWriter<Coordinate3DM>()
    }
    
    func testWrite_Point_2D() {
        
        XCTAssertEqual("POINT (1.0 1.0)", wktWriter2D.write(Point<Coordinate2D>(coordinate: (x:1.0, y:1.0))))
    }
    
    func testWrite_Point_2DM() {
        
        XCTAssertEqual("POINT M (1.0 2.0 3.0)", wktWriter2DM.write(Point<Coordinate2DM>(coordinate: (x:1.0, y:2.0, m:3.0))))
    }
    
    func testWrite_Point_3D() {
        
        XCTAssertEqual("POINT Z (1.0 2.0 3.0)", wktWriter3D.write(Point<Coordinate3D>(coordinate: (x:1.0, y:2.0, z:3.0))))
    }
    
    func testWrite_Point_3DM() {
        
        XCTAssertEqual("POINT ZM (1.0 2.0 3.0 4.0)", wktWriter3DM.write(Point<Coordinate3DM>(coordinate: (x:1.0, y:2.0, z:3.0, m:4.0))))
    }
    
    func testWrite_LineString_Empty() {
        
        let emptyLineString = LineString<Coordinate2D>()
        
        XCTAssertEqual("LINESTRING EMPTY", wktWriter2D.write(emptyLineString))
    }
    
    func testWrite_LineString_2D() {
        
        XCTAssertEqual("LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)", wktWriter2D.write(LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0)])))
    }
    
//    func testWrite_LineString_2DM() {
//        
//        XCTAssertEqual("linestring m (1.0 1.0 7.0, 2.0 2.0 8.0, 3.0 3.0 9.0)", wktWriter2D.write(LineString<Coordinate2DM>(elements: [(1.0, 1.0, 7.0), (2.0, 2.0, 8.0), (3.0, 3.0, 9.0)])))
//    }
//    
//    func testWrite_LineString_3D() {
//        
//        XCTAssertEqual("linestring z (1.0 1.0 4.0, 2.0 2.0 5.0, 3.0 3.0 6.0)", wktWriter3D.write(LineString<Coordinate3D>(elements: [(1.0, 1.0, 4.0), (2.0, 2.0, 5.0), (3.0, 3.0, 6.0)])))
//    }
//    
//    func testWrite_LineString_3DM() {
//        
//        XCTAssertEqual("linestring zm (1.0 1.0, 2.0 2.0, 3.0 3.0)", wktWriter3DM.write(LineString<Coordinate3DM>(elements: [(1.0, 1.0, 4.0, 7.0), (2.0, 2.0, 5.0, 8.0), (3.0, 3.0, 6.0, 9.0)])))
//    }
    
    func testWrite_Polygon_Empty() {
        
        XCTAssertEqual("POLYGON EMPTY", wktWriter2D.write(Polygon<Coordinate2D>()))
    }
    
    func testWrite_Polygon_2D() {
        
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])
        
        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))", wktWriter2D.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])))
    }
    
    func testWrite_Polygon_2D_ZeroInnerRings() {
        
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        
        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0))", wktWriter2D.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [])))
    }
    
    func testWrite_MultiPoint_2D_SinglePoint() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0))])
        
        XCTAssertEqual("MULTIPOINT ((1.0 1.0))", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2D_TwoPoints() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0)), Point<Coordinate2D>(coordinate: (x:2.0, y:2.0))])
        
        XCTAssertEqual("MULTIPOINT ((1.0 1.0), (2.0 2.0))", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2D_Empty() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [])
        
        XCTAssertEqual("MULTIPOINT EMPTY", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiLineString_Empty() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [])
        
        XCTAssertEqual("MULTILINESTRING EMPTY", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_SingleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)])])
        
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0))", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_MultipleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)]), LineString<Coordinate2D>(elements: [(x:3.0, y:3.0), (x:4.0, y:4.0)])])
        
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiPolygon_2D() {
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])
        
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)), ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)))", wktWriter2D.write(MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])])))
    }
    
    func testWrite_GeometryCollection_2D() {
        
        var geometryCollection = GeometryCollection()
        
        geometryCollection.append(Point<Coordinate2D>(coordinate: (x:1.0, y:2.0)))
        geometryCollection.append(Point<Coordinate2D>(coordinate: (x:10.0, y:20.0)))
        geometryCollection.append(LineString<Coordinate2D>(elements: [(x:3.0, y:4.0)]))
        geometryCollection.append(LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)]))
        geometryCollection.append(Polygon<Coordinate2D>(outerRing: LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)]), innerRings: [LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])]))
        
        XCTAssertEqual("GEOMETRYCOLLECTION (POINT (1.0 2.0), POINT (10.0 20.0), LINESTRING (3.0 4.0), LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)))", wktWriter2D.write(geometryCollection))
    }
}