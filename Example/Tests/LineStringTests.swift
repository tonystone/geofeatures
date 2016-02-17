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
        XCTAssertEqual(LineString().isEmpty, true)
    }
    
    func testInit_Double2DTuple_FloatingPrecision() {
        
        XCTAssertEqual(
            (LineString(coordinates: [(10.0,10.0)]).elementsEqual([(10.0,10.0,Double.NaN)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 2)
            }
        ), true)
    }
    
    func testInit_Double2DTuple_FixedPrecision() {
        let fixed = FixedPrecision(scale: 100)
        
        XCTAssertEqual(
            (LineString(coordinates: [(10.03,10.04)], precision: fixed).elementsEqual([(10.03,10.04,Double.NaN)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 2)
                }
            ), true)
    }
    
    func testInit_Double2DTuple_FixedPrecision_Truncated() {
        let fixed = FixedPrecision(scale: 100)
        
        XCTAssertEqual(
            (LineString(coordinates: [(10.003,10.004)], precision: fixed).elementsEqual([(10.0,10.0,Double.NaN)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 2)
                }
            ), true)
    }
    
    func testInit_Double3DTuple_FloatingPrecision() {
        
        XCTAssertEqual(
            (LineString(coordinates: [(10.0,10.0,10.0)]).elementsEqual([(10.0,10.0,10.0)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 3)
                }
            ), true)
    }
    
    func testInit_Int2DTuple_FloatingPrecision() {
        
        XCTAssertEqual(
            (LineString(coordinates: [(10,10)]).elementsEqual([(10.0,10.0,Double.NaN)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 2)
                }
            ), true)
    }
    
    func testInit_Int3DTuple_FloatingPrecision() {
        
        XCTAssertEqual(
            (LineString(coordinates: [(10,10,10)]).elementsEqual([(10.0,10.0,10.0)])
                { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                    return coordinateEquals(lhs, rhs, dimension: 3)
                }
            ), true)
    }
    
    // MARK: CollectionType
    
    func testSubscript_Get () {
        let lineString = LineString(coordinates: [(10,10,10),(20,20,20)])
        
        XCTAssertEqual(coordinateEquals(lineString[1], (20,20,20), dimension: 3), true)
    }
    
    func testSubscript_Set () {
        var lineString = LineString(coordinates: [(10,10,10),(20,20,20)])
        
        lineString[1] = (10,10,10)
        
        XCTAssertEqual(coordinateEquals(lineString[1], (10,10,10), dimension: 3), true)
    }
    
    func testAppendContentsOf_LineString () {
        
        let lineString1 = LineString(coordinates: [(10,10,10),(20,20,20)])
        var lineString2 = LineString()
        
        lineString2.appendContentsOf(lineString1)
        
        XCTAssertEqual(lineString1.equals(lineString2), true)
    }
    
    func testAppendContentsOf_Array () {
        
        let array      = [(10.0,10.0,10.0),(20.0,20.0,20.0)]
        var lineString2 = LineString()
        
        lineString2.appendContentsOf(array)
        
        XCTAssertEqual(lineString2.elementsEqual(array) { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
            return coordinateEquals(lineString2[1], (20,20,20), dimension: 3)
        }, true)
    }
    
    // MARK: Equal
    
    func testEquals_Int3D () {
        XCTAssertEqual(LineString(coordinates: [(10,10,10)]).equals(LineString(coordinates: [(10.0,10.0,10.0)])), true)
    }
    
    func testEquals_Int2D () {
        XCTAssertEqual(LineString(coordinates: [(10,10)]).equals(LineString(coordinates: [(10.0,10.0,Double.NaN)])), true)
    }
    
    // MARK: isEmpty
    
    func testIsEmpty_True() {
        XCTAssertEqual(LineString().isEmpty(), true)
    }
    
    func testIsEmpty_False() {
        XCTAssertEqual(LineString(coordinates: [(10,10,10)]).isEmpty(), false)
    }
    
    func testCount () {
        XCTAssertEqual(LineString(coordinates: [(10,10,10),(20,20,20),(30,30,30)]).count, 3)
    }
    
    func testAppend () {
        var lineString = LineString()
        
        lineString.append((10,10,10))
        
        XCTAssertEqual(lineString.elementsEqual([(10.0,10.0,10.0)])
            { (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool in
                return coordinateEquals(lhs, rhs, dimension:  3)
        }, true)
    }

}
