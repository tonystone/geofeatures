//
//  FloatingPrecisionTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class FloatingPrecisionTests: XCTestCase {

    let precision  = FloatingPrecision()
    
    func testConvert_Equal() {
        XCTAssertEqual(precision.convert(100.003), 100.003)
    }
    
    func testConvert_NotEqual1() {
        XCTAssertNotEqual(precision.convert(100.0), 100.003)
    }
    
    func testConvert_NotEqual2() {
        XCTAssertNotEqual(precision.convert(100.003), 100.0003)
    }

}
