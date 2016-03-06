//
//  WKTReaderTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

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
    
    func testRead_LineStrint_Valid() {
        
        do {
            let geometry = try WKTReader<Coordinate2D>.read("LINESTRING(1.0 1.0, 2.0 2.0, 3.0 3.0)")
            
            XCTAssertEqual(geometry == LineString<Coordinate2D>(elements: [(1.0, 1.0), (2.0, 2.0), (3.0, 3.0)]), true)
        } catch {
            XCTFail("Parsing failed: \(error).")
        }
    }
}
