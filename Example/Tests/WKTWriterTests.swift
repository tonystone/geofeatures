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
    
    func testWrite_LineString_2D_Empty() {
        
        let emptyLineString = LineString<Coordinate2D>()
        
        XCTAssertEqual("LINESTRING EMPTY", wktWriter2D.write(emptyLineString))
    }
    
    func testWrite_LineString_2D_singlePoint() {
        
        XCTAssertEqual("LINESTRING (1.0 1.0)", wktWriter2D.write(LineString<Coordinate2D>(elements: [(x:1.0, y:1.0)])))
    }
    
    func testWrite_LineString_2D_multiplePoints() {
        
        XCTAssertEqual("LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)", wktWriter2D.write(LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0)])))
    }
    
    func testWrite_LineString_2DM_Empty() {
        
        let emptyLineString = LineString<Coordinate2DM>()
        
        // FIXME: should be LINESTRING M EMPTY
        XCTAssertEqual("LINESTRING EMPTY", wktWriter2DM.write(emptyLineString))
    }
    
    func testWrite_LineString_2DM_singlePoint() {
        
        // FIXME: should be LINESTRING M [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 2.0)", wktWriter2DM.write(LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0)])))
    }
    
    func testWrite_LineString_2DM_multiplePoints() {
        
        // FIXME: should be LINESTRING M [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0)", wktWriter2DM.write(LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0)])))
    }
    
    func testWrite_LineString_3D_Empty() {
        
        let emptyLineString = LineString<Coordinate3D>()
        
        // FIXME: should be LINESTRING Z EMPTY
        XCTAssertEqual("LINESTRING EMPTY", wktWriter3D.write(emptyLineString))
    }
    
    func testWrite_LineString_3D_singlePoint() {
        
        // FIXME: should be LINESTRING Z (1.0, 1.0, 1.0)
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0)", wktWriter3D.write(LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0)])))
    }
    
    func testWrite_LineString_3D_multiplePoints() {
        
        // FIXME: should be LINESTRING Z [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0)", wktWriter3D.write(LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0)])))
    }

    func testWrite_LineString_3DM_Empty() {
        
        let emptyLineString = LineString<Coordinate3DM>()
        
        // FIXME: should be LINESTRING ZM EMPTY
        XCTAssertEqual("LINESTRING EMPTY", wktWriter3DM.write(emptyLineString))
    }
    
    func testWrite_LineString_3DM_singlePoint() {
        
        // FIXME: should be LINESTRING ZM [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0 3.0)", wktWriter3DM.write(LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0)])))
    }
    
    func testWrite_LineString_3DM_multiplePoints() {
        
        // FIXME: should be LINESTRING ZM [..]
        XCTAssertEqual("LINESTRING (1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0)", wktWriter3DM.write(LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z: 1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0)])))
    }
    
    func testWrite_LinearRing_2D_Empty() {
        
        let emptyLinearRing = LinearRing<Coordinate2D>()
        
        XCTAssertEqual("LINEARRING EMPTY", wktWriter2D.write(emptyLinearRing))
    }
    
    func testWrite_LinearRing_2D() {
        
        XCTAssertEqual("LINEARRING (1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)", wktWriter2D.write(LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])))
    }
    
    func testWrite_LinearRing_2DM_Empty() {
        
        let emptyLinearRing = LinearRing<Coordinate2DM>()
        
        // FIXME: should be LINEARSTRING M EMPTY
        XCTAssertEqual("LINEARRING EMPTY", wktWriter2DM.write(emptyLinearRing))
    }
    
    func testWrite_LinearRing_2DM() {
        
        // FIXME: should be LINEARSTRING M [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0)", wktWriter2DM.write(LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m: 2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])))
    }
    
    func testWrite_LinearRing_3D_Empty() {
        
        let emptyLinearRing = LinearRing<Coordinate3D>()
        
        // FIXME: should be LINEARRING Z EMPTY
        XCTAssertEqual("LINEARRING EMPTY", wktWriter3D.write(emptyLinearRing))
    }
    
    func testWrite_LinearRing_3D() {
        
        // FIXME: should be LINEARRING Z [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0)", wktWriter3D.write(LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])))
    }
    
    func testWrite_LinearRing_3DM_Empty() {
        
        let emptyLinearRing = LinearRing<Coordinate3DM>()
        
        // FIXME: should be LINEARSTRING ZM EMPTY
        XCTAssertEqual("LINEARRING EMPTY", wktWriter3DM.write(emptyLinearRing))
    }
    
    func testWrite_LinearRing_3DM() {
        
        // FIXME: should be LINEARSTRING ZM [..]
        XCTAssertEqual("LINEARRING (1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0)", wktWriter3DM.write(LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m: 3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])))
    }
    
    func testWrite_Polygon_2D_Empty() {
        
        XCTAssertEqual("POLYGON EMPTY", wktWriter2D.write(Polygon<Coordinate2D>()))
    }
    
    func testWrite_Polygon_2DM_Empty() {
        
        // FIXME: should be POLYGON M
        XCTAssertEqual("POLYGON EMPTY", wktWriter2DM.write(Polygon<Coordinate2DM>()))
    }
    
    func testWrite_Polygon_3D_Empty() {
        
        // FIXME: should be POLYGON Z
        XCTAssertEqual("POLYGON EMPTY", wktWriter3D.write(Polygon<Coordinate3D>()))
    }
    
    func testWrite_Polygon_3DM_Empty() {
        
        // FIXME: should be POLYGON ZM
        XCTAssertEqual("POLYGON EMPTY", wktWriter3DM.write(Polygon<Coordinate3DM>()))
    }
    
    func testWrite_Polygon_2D() {
        
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])
        
        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))", wktWriter2D.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])))
    }
    
    func testWrite_Polygon_2DM() {
        
        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])
        let innerRing = LinearRing<Coordinate2DM>(elements: [(x:4.0, y:4.0, m:8.0), (x:5.0, y:5.0, m:10.0), (x:6.0, y:6.0, m:12.0), (x:4.0, y:4.0, m:8.0)])
        
        // FIXME: should be POLYGON M [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0))", wktWriter2DM.write(Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing])))
    }
    
    func testWrite_Polygon_3D() {
        
        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])
        let innerRing = LinearRing<Coordinate3D>(elements: [(x:4.0, y:4.0, z:4.0), (x:5.0, y:5.0, z:5.0), (x:6.0, y:6.0, z:6.0), (x:4.0, y:4.0, z:4.0)])
        
        // FIXME: should be POLYGON Z [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0))", wktWriter3D.write(Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing])))
    }
    
    func testWrite_Polygon_3DM() {
        
        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])
        let innerRing = LinearRing<Coordinate3DM>(elements: [(x:4.0, y:4.0, z:4.0, m:12.0), (x:5.0, y:5.0, z:5.0, m:15.0), (x:6.0, y:6.0, z:6.0, m:18.0), (x:4.0, y:4.0, z:4.0, m:12.0)])
        
        // FIXME: should be POLYGON ZM [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0))", wktWriter3DM.write(Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing])))
    }
    
    func testWrite_Polygon_2D_ZeroInnerRings() {
        
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        
        XCTAssertEqual("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0))", wktWriter2D.write(Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [])))
    }
    
    func testWrite_Polygon_2DM_ZeroInnerRings() {
        
        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])
    
        // FIXME: should be POLYGON M [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0))", wktWriter2DM.write(Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [])))
    }
        
    func testWrite_Polygon_3D_ZeroInnerRings() {
        
        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])
        
        // FIXME: should be POLYGON Z [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0))", wktWriter3D.write(Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [])))
    }
        
    func testWrite_Polygon_3DM_ZeroInnerRings() {
        
        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])
        
        // FIXME: should be POLYGON ZM [..]
        XCTAssertEqual("POLYGON ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0))", wktWriter3DM.write(Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [])))
    }
    
    func testWrite_MultiPoint_2D_Empty() {
        
        let emptyMultiPoint = MultiPoint<Coordinate2D>(elements: [])
        
        XCTAssertEqual("MULTIPOINT EMPTY", wktWriter2D.write(emptyMultiPoint))
    }
    
    func testWrite_MultiPoint_2DM_Empty() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [])
        
        // FIXME: should be MULTIPOINT M EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3D_Empty() {
        
        let multiPoint = MultiPoint<Coordinate3D>(elements: [])
        
        // FIXME: should be MULTIPOINT Z EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", wktWriter3D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3DM_Empty() {
        
        let multiPoint = MultiPoint<Coordinate3DM>(elements: [])
        
        // FIXME: should be MULTIPOINT ZM EMPTY
        XCTAssertEqual("MULTIPOINT EMPTY", wktWriter3DM.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2D_SinglePoint() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0))])
        
        XCTAssertEqual("MULTIPOINT ((1.0 1.0))", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2DM_SinglePoint() {
        
        let multiPoint = MultiPoint<Coordinate2DM>(elements: [Point<Coordinate2DM>(coordinate: (x:1.0, y:1.0, m: 2.0))])
        
        // FIXME: should be MULTIPOINT M [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0))", wktWriter2DM.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3D_SinglePoint() {
        
        let multiPoint = MultiPoint<Coordinate3D>(elements: [Point<Coordinate3D>(coordinate: (x:1.0, y:1.0, z: 2.0))])
        
        // FIXME: should be MULTIPOINT Z [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0))", wktWriter3D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3DM_SinglePoint() {
        
        let multiPoint = MultiPoint<Coordinate3DM>(elements: [Point<Coordinate3DM>(coordinate: (x:1.0, y:1.0, z: 1.0, m: 3.0))])
        
        // FIXME: should be MULTIPOINT ZM [..]
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0 3.0))", wktWriter3DM.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2D_TwoPoints() {
        
        let multiPoint = MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x:1.0, y:1.0)), Point<Coordinate2D>(coordinate: (x:2.0, y:2.0))])
        
        XCTAssertEqual("MULTIPOINT ((1.0 1.0), (2.0 2.0))", wktWriter2D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_2DM_TwoPoints() {
        
        let multiPoint = MultiPoint<Coordinate2DM>(elements: [Point<Coordinate2DM>(coordinate: (x:1.0, y:1.0, m:2.0)), Point<Coordinate2DM>(coordinate: (x:2.0, y:2.0, m:4.0))])
        
        // FIXME: should be MULTIPOINT M
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 2.0), (2.0 2.0 4.0))", wktWriter2DM.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3D_TwoPoints() {
        
        let multiPoint = MultiPoint<Coordinate3D>(elements: [Point<Coordinate3D>(coordinate: (x:1.0, y:1.0, z:1.0)), Point<Coordinate3D>(coordinate: (x:2.0, y:2.0, z:2.0))])
        
        // FIXME: should be MULTIPOINT Z
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0), (2.0 2.0 2.0))", wktWriter3D.write(multiPoint))
    }
    
    func testWrite_MultiPoint_3DM_TwoPoints() {
        
        let multiPoint = MultiPoint<Coordinate3DM>(elements: [Point<Coordinate3DM>(coordinate: (x:1.0, y:1.0, z:1.0, m:3.0)), Point<Coordinate3DM>(coordinate: (x:2.0, y:2.0, z:2.0, m:6.0))])
        
        // FIXME: should be MULTIPOINT ZM
        XCTAssertEqual("MULTIPOINT ((1.0 1.0 1.0 3.0), (2.0 2.0 2.0 6.0))", wktWriter3DM.write(multiPoint))
    }
    
    func testWrite_MultiLineString_2D_Empty() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [])
        
        XCTAssertEqual("MULTILINESTRING EMPTY", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_2DM_Empty() {
        
        let multiLineString = MultiLineString<Coordinate2DM>(elements: [])
        
        // FIXME: should be MULTILINESTRING M EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", wktWriter2DM.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3D_Empty() {
        
        let multiLineString = MultiLineString<Coordinate3D>(elements: [])
        
        // FIXME: should be MULTILINESTRING Z EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", wktWriter3D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3DM_Empty() {
        
        let multiLineString = MultiLineString<Coordinate3DM>(elements: [])
        
        // FIXME: should be MULTILINESTRING ZM EMPTY
        XCTAssertEqual("MULTILINESTRING EMPTY", wktWriter3DM.write(multiLineString))
    }
    
    func testWrite_MultiLineString_2D_SingleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)])])
        
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0))", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_2DM_SingleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2DM>(elements: [LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m: 2.0), (x:2.0, y:2.0, m:4.0)])])
        
        // FIXME: should be MULTILINESTRING M [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 2.0, 2.0 2.0 4.0))", wktWriter2DM.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3D_SingleLineString() {
        
        let multiLineString = MultiLineString<Coordinate3D>(elements: [LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0)])])
        
        // FIXME: should be MULTILINESTRING Z [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0, 2.0 2.0 2.0))", wktWriter3D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3DM_SingleLineString() {
        
        let multiLineString = MultiLineString<Coordinate3DM>(elements: [LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0)])])
        
        // FIXME: should be MULTILINESTRING ZM [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0))", wktWriter3DM.write(multiLineString))
    }
    
    func testWrite_MultiLineString_2D_MultipleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2D>(elements: [LineString<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0)]), LineString<Coordinate2D>(elements: [(x:3.0, y:3.0), (x:4.0, y:4.0)])])
        
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))", wktWriter2D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_2DM_MultipleLineString() {
        
        let multiLineString = MultiLineString<Coordinate2DM>(elements: [LineString<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0)]), LineString<Coordinate2DM>(elements: [(x:3.0, y:3.0, m:6.0), (x:4.0, y:4.0, m:8.0)])])
        
        // FIXME: should be MULTILINESTRING M [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 2.0, 2.0 2.0 4.0), (3.0 3.0 6.0, 4.0 4.0 8.0))", wktWriter2DM.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3D_MultipleLineString() {
        
        let multiLineString = MultiLineString<Coordinate3D>(elements: [LineString<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0)]), LineString<Coordinate3D>(elements: [(x:3.0, y:3.0, z:3.0), (x:4.0, y:4.0, z:4.0)])])
        
        // FIXME: should be MULTILINESTRING Z [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0, 2.0 2.0 2.0), (3.0 3.0 3.0, 4.0 4.0 4.0))", wktWriter3D.write(multiLineString))
    }
    
    func testWrite_MultiLineString_3DM_MultipleLineString() {
        
        let multiLineString = MultiLineString<Coordinate3DM>(elements: [LineString<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0)]), LineString<Coordinate3DM>(elements: [(x:3.0, y:3.0, z:3.0, m:9.0), (x:4.0, y:4.0, z:4.0, m:12.0)])])
        
        // FIXME: should be MULTILINESTRING ZM [..]
        XCTAssertEqual("MULTILINESTRING ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0), (3.0 3.0 3.0 9.0, 4.0 4.0 4.0 12.0))", wktWriter3DM.write(multiLineString))
    }
    
    func testWrite_MultiPolygon_2D_Empty() {
        
        let emptyMultiPolygon = MultiPolygon<Coordinate2D>()
        
        XCTAssertEqual("MULTIPOLYGON EMPTY", wktWriter2D.write(emptyMultiPolygon))
    }
    
    func testWrite_MultiPolygon_2DM_Empty() {
        
        let emptyMultiPolygon = MultiPolygon<Coordinate2DM>()
        
        // FIXME: should be MULTIPOLYGON M EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", wktWriter2DM.write(emptyMultiPolygon))
    }
    
    func testWrite_MultiPolygon_3D_Empty() {
        
        let emptyMultiPolygon = MultiPolygon<Coordinate3D>()
        
        // FIXME: should be MULTIPOLYGON Z EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", wktWriter3D.write(emptyMultiPolygon))
    }
    
    func testWrite_MultiPolygon_3DM_Empty() {
        
        let emptyMultiPolygon = MultiPolygon<Coordinate3DM>()
        
        // FIXME: should be MULTIPOLYGON ZM EMPTY
        XCTAssertEqual("MULTIPOLYGON EMPTY", wktWriter3DM.write(emptyMultiPolygon))
    }
    
    func testWrite_MultiPolygon_2D() {
        let outerRing = LinearRing<Coordinate2D>(elements: [(x:1.0, y:1.0), (x:2.0, y:2.0), (x:3.0, y:3.0), (x:1.0, y:1.0)])
        let innerRing = LinearRing<Coordinate2D>(elements: [(x:4.0, y:4.0), (x:5.0, y:5.0), (x:6.0, y:6.0), (x:4.0, y:4.0)])
        
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)), ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0)))", wktWriter2D.write(MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing])])))
    }
    
    func testWrite_MultiPolygon_2DM() {
        let outerRing = LinearRing<Coordinate2DM>(elements: [(x:1.0, y:1.0, m:2.0), (x:2.0, y:2.0, m:4.0), (x:3.0, y:3.0, m:6.0), (x:1.0, y:1.0, m:2.0)])
        let innerRing = LinearRing<Coordinate2DM>(elements: [(x:4.0, y:4.0, m:8.0), (x:5.0, y:5.0, m:10.0), (x:6.0, y:6.0, m:12.0), (x:4.0, y:4.0, m:8.0)])
        
        // FIXME: should be MULTIPOLYGON M [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0)), ((1.0 1.0 2.0, 2.0 2.0 4.0, 3.0 3.0 6.0, 1.0 1.0 2.0), (4.0 4.0 8.0, 5.0 5.0 10.0, 6.0 6.0 12.0, 4.0 4.0 8.0)))", wktWriter2DM.write(MultiPolygon<Coordinate2DM>(elements: [Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate2DM>(outerRing: outerRing, innerRings: [innerRing])])))
    }
    
    func testWrite_MultiPolygon_3D() {
        let outerRing = LinearRing<Coordinate3D>(elements: [(x:1.0, y:1.0, z:1.0), (x:2.0, y:2.0, z:2.0), (x:3.0, y:3.0, z:3.0), (x:1.0, y:1.0, z:1.0)])
        let innerRing = LinearRing<Coordinate3D>(elements: [(x:4.0, y:4.0, z:4.0), (x:5.0, y:5.0, z:5.0), (x:6.0, y:6.0, z:6.0), (x:4.0, y:4.0, z:4.0)])
        
        // FIXME: should be MULTIPOLYGON Z [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0)), ((1.0 1.0 1.0, 2.0 2.0 2.0, 3.0 3.0 3.0, 1.0 1.0 1.0), (4.0 4.0 4.0, 5.0 5.0 5.0, 6.0 6.0 6.0, 4.0 4.0 4.0)))", wktWriter3D.write(MultiPolygon<Coordinate3D>(elements: [Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate3D>(outerRing: outerRing, innerRings: [innerRing])])))
    }
    
    func testWrite_MultiPolygon_3DM() {
        let outerRing = LinearRing<Coordinate3DM>(elements: [(x:1.0, y:1.0, z:1.0, m:3.0), (x:2.0, y:2.0, z:2.0, m:6.0), (x:3.0, y:3.0, z:3.0, m:9.0), (x:1.0, y:1.0, z:1.0, m:3.0)])
        let innerRing = LinearRing<Coordinate3DM>(elements: [(x:4.0, y:4.0, z:4.0, m:12.0), (x:5.0, y:5.0, z:5.0, m:15.0), (x:6.0, y:6.0, z:6.0, m:18.0), (x:4.0, y:4.0, z:4.0, m:12.0)])
        
        // FIXME: should be MULTIPOLYGON ZM [..]
        XCTAssertEqual("MULTIPOLYGON (((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0)), ((1.0 1.0 1.0 3.0, 2.0 2.0 2.0 6.0, 3.0 3.0 3.0 9.0, 1.0 1.0 1.0 3.0), (4.0 4.0 4.0 12.0, 5.0 5.0 5.0 15.0, 6.0 6.0 6.0 18.0, 4.0 4.0 4.0 12.0)))", wktWriter3DM.write(MultiPolygon<Coordinate3DM>(elements: [Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing]), Polygon<Coordinate3DM>(outerRing: outerRing, innerRings: [innerRing])])))
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