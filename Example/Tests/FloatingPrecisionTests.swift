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

    func testConvert_Equal() {
        let precision  = FloatingPrecision()
        
        XCTAssertEqual(precision.convert(100.003) == precision.convert(100.003), true)
    }
    
    func testConvert_NotEqual1() {
        let precision  = FloatingPrecision()
        
        XCTAssertEqual(precision.convert(100.0) == precision.convert(100.003), false)
    }
    
    func testConvert_NotEqual2() {
        let precision  = FloatingPrecision()
        
        XCTAssertEqual(precision.convert(100.003) == precision.convert(100.0003), false)
    }

}
