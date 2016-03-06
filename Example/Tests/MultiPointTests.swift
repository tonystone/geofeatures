//
//  MultiPointTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 3/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class MultiPointTests: XCTestCase {

    // MARK: Init
    
    func testInit_NoArg ()   {
        XCTAssertEqual(MultiPoint<Coordinate2D>(precision: FloatingPrecision()).isEmpty, true)
    }
    
    func testInit_Tuple () {
    
        XCTAssertEqual(
            (LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0),(x: 2.0, y: 2.0)], precision: FloatingPrecision()).elementsEqual([Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))])
                { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                    return lhs == rhs
            }
        ), true)
    }
    
    // MARK: CollectionType
    
    func testSubscript_Get () {
        let lineString = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0),(x: 2.0, y: 2.0)], precision: FloatingPrecision())
        
        XCTAssertEqual(lineString[1] == Coordinate2D(tuple: (x: 2.0, y: 2.0)), true)
    }
    
    func testSubscript_Set () {
        var lineString = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0),(x: 2.0, y: 2.0)], precision: FloatingPrecision())
        
        lineString[1] = Coordinate2D(tuple: (x: 1.0, y: 1.0))
        
        XCTAssertEqual(lineString[1] ==  Coordinate2D(tuple: (x: 1.0, y: 1.0)), true)
    }
    
    func testAppendContentsOf_LineString () {
        
        let lineString1 = LineString<Coordinate2D>(elements: [(x: 1.0, y: 1.0),(x: 2.0, y: 2.0)], precision: FloatingPrecision())
        var lineString2 = LineString<Coordinate2D>(precision: FloatingPrecision())
        
        lineString2.appendContentsOf(lineString1)
        
        XCTAssertEqual(lineString1 == lineString2, true)
    }
    
    func testAppendContentsOf_Array () {
        
        var lineString2 = LineString<Coordinate2D>(precision: FloatingPrecision())
        
        lineString2.appendContentsOf([Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))])
        
        XCTAssertEqual(lineString2.elementsEqual([Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))]) { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
            return lhs == rhs
        }, true)
    }
    
    // MARK: Equal
    
    func testEquals () {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))], precision: FloatingPrecision()).equals(LineString<Coordinate2D>(elements: [Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))])), true)
    }
    
    // MARK: isEmpty
    
    func testIsEmpty () {
        XCTAssertEqual(LineString<Coordinate2D>(precision: FloatingPrecision()).isEmpty(), true)
    }
    
    func testIsEmpty_False() {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))], precision: FloatingPrecision()).isEmpty(), false)
    }
    
    func testCount () {
        XCTAssertEqual(LineString<Coordinate2D>(elements: [Coordinate2D(tuple: (x: 1.0, y: 1.0)), Coordinate2D(tuple: (x: 2.0, y: 2.0))], precision: FloatingPrecision()).count, 2)
    }
    
    func testAppend () {
        var lineString = LineString<Coordinate2D>(precision: FloatingPrecision())
        
        lineString.append((x: 1.0, y: 1.0))
        
        XCTAssertEqual(lineString.elementsEqual([Coordinate2D(tuple: (x: 1.0, y: 1.0))])
            { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                return lhs == rhs
        }, true)
    }

}
