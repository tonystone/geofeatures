//
//  FixedPrecisionTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import GeoFeatures2

class FixedPrecisionTests: XCTestCase {

    func testConvert_Scale1000_Equal() {
        let precision  = FixedPrecision(scale: 1000)
        
        XCTAssertEqual(precision.convert(100.003) == precision.convert(100.003), true)
    }
    
    func testConvert_Scale1000_NotEqual() {
        let precision  = FixedPrecision(scale: 1000)
        
        XCTAssertEqual(precision.convert(100.0) == precision.convert(100.003), false)
    }
    
    func testConvert_Scale1000_Truncated_Equal() {
        let precision  = FixedPrecision(scale: 1000)

        XCTAssertEqual(precision.convert(100.0) == precision.convert(100.0003), true)
    }
    
    func testConvert_Scale1000_Truncated_NotEqual() {
        let precision  = FixedPrecision(scale: 1000)
        
        XCTAssertEqual(precision.convert(100.003) == precision.convert(100.0003), false)
    }

}
