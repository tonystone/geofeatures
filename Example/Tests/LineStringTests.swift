/*
 *   LineStringTests.swift
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
@testable import GeoFeatures2

class LineStringTests: XCTestCase {

    // MARK: Init
    
    func testInit_NoArg()   {
        XCTAssertEqual(LineString<Coordinate2D>().isEmpty, true)
    }
    
    func testInit_Double2DTuple_FloatingPrecision() {
        let precision = FloatingPrecision()
        
        XCTAssertEqual(
            (LineString<Coordinate2D>(coordinates: [(10.0,10.0)], precision: precision).elementsEqual([Coordinate2D(tuple: (10.0,10.0))])
                { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                    return lhs == rhs
            }
        ), true)
    }
    
    func testInit_Double2DTuple_FixedPrecision() {
        let precision = FixedPrecision(scale: 100)
        
        XCTAssertEqual(
            (LineString<Coordinate2D>(coordinates: [(10.03,10.04)], precision: precision).elementsEqual([Coordinate2D(tuple: (10.03,10.04))])
                { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                    return lhs == rhs
                }
            ), true)
    }
    
    func testInit_Double2DTuple_FixedPrecision_Truncated() {
        let precision = FixedPrecision(scale: 100)
        
        XCTAssertEqual(
            (LineString<Coordinate2D>(coordinates: [(10.033,10.043)], precision: precision).elementsEqual([Coordinate2D(tuple: (10.03,10.04))])
                { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                    return lhs == rhs
                }
            ), true)
    }
    
    func testInit_Double3DTuple_FloatingPrecision() {
        let precision = FloatingPrecision()
        
        XCTAssertEqual(
            (LineString<Coordinate3D>(coordinates: [(10.0,10.0,10.0)], precision: precision).elementsEqual([Coordinate3D(tuple: (10.0,10.0,10.0))])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return lhs == rhs
                }
            ), true)
    }
    
    func testInit_Int2DTuple_FloatingPrecision() {
        let precision = FloatingPrecision()
        
        XCTAssertEqual(
            (LineString(coordinates: [(10,10)], precision: precision).elementsEqual([Coordinate2D(tuple: (10.0,10.0))])
                { (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool in
                    return lhs == rhs
                }
            ), true)
    }
    
    func testInit_Int3DTuple_FloatingPrecision() {
        let precision = FloatingPrecision()
        
        XCTAssertEqual(
            (LineString(coordinates: [(10,10,10)], precision: precision).elementsEqual([Coordinate3D(tuple: (10.0,10.0,10.0))])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return lhs == rhs
                }
            ), true)
    }
    
    // MARK: CollectionType
    
    func testSubscript_Get () {
        let lineString = LineString<Coordinate3D>(coordinates: [(10,10,10),(20,20,20)])
        
        XCTAssertEqual(lineString[1] == Coordinate3D(tuple: (20,20,20)), true)
    }
    
    func testSubscript_Set () {
        var lineString = LineString<Coordinate3D>(coordinates: [(10,10,10),(20,20,20)])
        
        lineString[1] = Coordinate3D(tuple: (10,10,10))
        
        XCTAssertEqual(lineString[1] ==  Coordinate3D(tuple: (10,10,10)), true)
    }
    
    func testAppendContentsOf_LineString () {
        
        let lineString1 = LineString<Coordinate3D>(coordinates: [(10,10,10),(20,20,20)])
        var lineString2 = LineString<Coordinate3D>()
        
        lineString2.appendContentsOf(lineString1)
        
        XCTAssertEqual(lineString1 == lineString2, true)
    }
    
    func testAppendContentsOf_Array () {
        
        let array      = [Coordinate3D(tuple: (10.0,10.0,10.0)),Coordinate3D(tuple: (20.0,20.0,20.0))]
        var lineString2 = LineString<Coordinate3D>()
        
        lineString2.appendContentsOf(array)
        
        XCTAssertEqual(lineString2.elementsEqual(array) { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
            return lhs == rhs
        }, true)
    }
    
    // MARK: Equal
    
    func testEquals_Int3D () {
        XCTAssertEqual(LineString<Coordinate3D>(coordinates: [(10,10,10)]).equals(LineString<Coordinate3D>(coordinates: [(10.0,10.0,10.0)])), true)
    }
    
    func testEquals_Int2D () {
        XCTAssertEqual(LineString<Coordinate2D>(coordinates: [(10,10)]).equals(LineString<Coordinate2D>(coordinates: [(10.0,10.0)])), true)
    }
    
    // MARK: isEmpty
    
    func testIsEmpty_True() {
        XCTAssertEqual(LineString<Coordinate2D>().isEmpty(), true)
    }
    
    func testIsEmpty_False() {
        XCTAssertEqual(LineString<Coordinate3D>(coordinates: [(10,10,10)]).isEmpty(), false)
    }
    
    func testCount () {
        XCTAssertEqual(LineString<Coordinate3D>(coordinates: [(10,10,10),(20,20,20),(30,30,30)]).count, 3)
    }
    
    func testAppend () {
        var lineString = LineString<Coordinate3D>()
        
        lineString.append((10,10,10))
        
        XCTAssertEqual(lineString.elementsEqual([Coordinate3D(tuple: (10.0,10.0,10.0))])
            { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                return lhs == rhs
        }, true)
    }

}
