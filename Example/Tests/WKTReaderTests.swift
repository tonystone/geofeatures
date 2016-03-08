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

    private var wktReader: WKTReader<Coordinate2D>!
    
    override func setUp() {
        wktReader = WKTReader(coordinateReferenceSystem: Cartesian(), precision: FloatingPrecision())
    }
    
    func testRead_Point_Float_Valid() {
        
        do {
            let geometry = try wktReader.read("POINT (1.0 1.0)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0, 1.0)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Int_Valid() {
        
        do {
            let geometry = try wktReader.read("POINT (1 1)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0, 1.0)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Invalid_WhiteSpace() {
        
        do {
            try wktReader.read("POINT  (   1.0     1.0   ) ")
            
            XCTFail("Parsing failed")
            
        } catch ParseError.UnexpectedToken {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Parsing failed")
        }
    }
    
    func testRead_Point_Valid_Exponent_UpperCase() {
        
        do {
            let geometry = try wktReader.read("POINT (1.0E-5 1.0E-5)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0E-5, 1.0E-5)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_Valid_Exponent_LowerCase() {
        
        do {
            let geometry = try wktReader.read("POINT (1.0e-5 1.0e-5)")
            
            XCTAssertEqual(geometry == Point<Coordinate2D>(coordinate: (1.0E-5, 1.0E-5)), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Point_InvalidCoordinate() {
        
        do {
            try wktReader.read("POINT (1.01.0)")
            
            XCTFail("Parsing failed")
            
        } catch ParseError.UnexpectedToken {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Parsing failed")
        }
    }
    
    func testRead_LineString_Valid() {
        
        do {
            let geometry = try wktReader.read("LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)")
            
            XCTAssertEqual(geometry == LineString<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }

    func testRead_MultiPoint_Valid() {

        do {
            let geometry1 = try wktReader.read("MULTIPOINT ((1.0 2.0))")

            XCTAssertEqual(geometry1 == MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0))]), true)

        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_MultiPoint_Invalid_MissingClosingParen() {
        
        do {
            try wktReader.read("MULTIPOINT ((1.0 2.0)")
            
            XCTFail("Parsing failed")
            
        } catch ParseError.UnexpectedToken {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Parsing failed")
        }
    }
    
    func testRead_MultiLineString_Valid() {
        
        do {
            let geometry = try wktReader.read("MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0))")
            
            XCTAssertEqual(geometry == MultiLineString<Coordinate2D>(elements: [LineString(elements:  [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]), LineString(elements:  [(4.0, 4.0), (5.0, 5.0), (6.0, 6.0)])]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_MultiLineString_Invalid_MissingCLosingParen() {
        
        do {
            try wktReader.read("MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0)")
            
            XCTFail("Parsing failed")
            
        } catch ParseError.UnexpectedToken {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Parsing failed")
        }
    }
    
    func testRead_Polygon_ZeroInnerRings_Valid() {
        
        do {
            let geometry = try wktReader.read("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0))")
            
            XCTAssertEqual(geometry == Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0), (1.0, 1.0)]), innerRings: []), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Polygon_SingleOuterRing_Valid() {
        
        do {
            let geometry = try wktReader.read("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0))")
            
            let outerRing = LinearRing<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0), (1.0, 1.0)])
            let innerRing = LinearRing<Coordinate2D>(elements: [(4.0, 4.0), (5.0, 5.0), (6.0, 6.0), (4.0, 4.0)])
            
            XCTAssertEqual(geometry == Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Polygon_MultipleOuterRings_Valid() {
        
        do {
            let geometry = try wktReader.read("POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0), (4.0 4.0, 5.0 5.0, 6.0 6.0, 4.0 4.0), (3.0 3.0, 4.0 4.0, 5.0 5.0, 3.0 3.0))")
            
            let outerRing = LinearRing<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0), (1.0, 1.0)])
            let innerRing1 = LinearRing<Coordinate2D>(elements: [(4.0, 4.0), (5.0, 5.0), (6.0, 6.0), (4.0, 4.0)])
            let innerRing2 = LinearRing<Coordinate2D>(elements: [(3.0, 3.0), (4.0, 4.0), (5.0, 5.0), (3.0, 3.0)])
            
            XCTAssertEqual(geometry == Polygon<Coordinate2D>(outerRing: outerRing, innerRings: [innerRing1, innerRing2]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_Polygon_MultipleOuterRings_Invalid_MissingComma() {
        
        do {
            try wktReader.read("MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0)")
            
            XCTFail("Parsing failed")
            
        } catch ParseError.UnexpectedToken {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Parsing failed")
        }
    }
    
    func testRead_MultiPolygon_Valid() {
        
        do {
            let geometry = try wktReader.read("MULTIPOLYGON (POLYGON ((1.0 1.0, 2.0 2.0, 3.0 3.0, 1.0 1.0)), POLYGON ((10.0 10.0, 20.0 20.0, 30.0 30.0, 10.0 10.0)))")
            
            XCTAssertEqual(geometry == MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0), (1.0, 1.0)]), innerRings: []), Polygon<Coordinate2D>(outerRing: LinearRing(elements: [(10.0, 10.0), (20.0, 20.0), (30.0, 30.0), (10.0, 10.0)]), innerRings: [])]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    
    func testRead_GeometryCollection_Valid() {
        
        do {
            let geometry = try wktReader.read("GEOMETRYCOLLECTION (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0), MULTIPOINT ((1.0 2.0)), MULTILINESTRING ((1.0 1.0, 2.0 2.0, 3.0 3.0), (4.0 4.0, 5.0 5.0, 6.0 6.0)), GEOMETRYCOLLECTION (POINT (1.0 1.0), LINESTRING (1.0 1.0, 2.0 2.0, 3.0 3.0)))")
            
            XCTAssertEqual(geometry == GeometryCollection(elements:
                [
                    Point<Coordinate2D>(coordinate: (1.0, 1.0)),
                    LineString<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]),
                    MultiPoint<Coordinate2D>(elements: [Point<Coordinate2D>(coordinate: (x: 1.0, y: 2.0))]),
                    MultiLineString<Coordinate2D>(elements: [LineString(elements:  [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]), LineString(elements:  [(4.0, 4.0), (5.0, 5.0), (6.0, 6.0)])]),
                    GeometryCollection(elements:  [
                            Point<Coordinate2D>(coordinate: (1.0, 1.0)),
                            LineString<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)])] as [Geometry])
                ] as [Geometry]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
    

}