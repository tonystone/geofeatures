//
//  FixedPrecisionTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class FixedPrecisionTests: XCTestCase {

    // MARK: FIxed 10
    
    func testConvert_Scale10_Lower() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.01) == 1.0, true)
    }
    
    func testConvert_Scale10_Middle() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.05) == 1.1, true)
    }
    
    func testConvert_Scale10_Upper() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.09) == 1.1, true)
    }
    
    func testConvert_Scale10_Lower2() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.0111) == 1.0, true)
    }
    
    func testConvert_Scale10_Middle2() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.0555) == 1.1, true)
    }
    
    func testConvert_Scale10_Upper2() {
        let precision  = FixedPrecision(scale: 10)
        
        XCTAssertEqual(precision.convert(1.0999) == 1.1, true)
    }
}
